Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F891AC3BC
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898688AbgDPNrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898685AbgDPNrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:47:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AA45208E4;
        Thu, 16 Apr 2020 13:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044852;
        bh=YT2uPu+CvbKPtXH7NT0G3Z7bnBFybUw4cBTirjFdyIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GkmhrybmWNBXjbeB+uVkEpcSZsoqllQYl4BIzaeCewp55/g4L8CiwNn67227o7ER
         nc96ua3Nivd6QdngvEoc8TGZV1AM3UxEgma63bQXVdcsXrDzgbzMB/TVlvn8n8NuiL
         gLlkZCuRrEpGQJmi+RtiCFBXRnAXLIJnjX7SGgMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.4 126/232] KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
Date:   Thu, 16 Apr 2020 15:23:40 +0200
Message-Id: <20200416131330.817189531@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit a1d032a49522cb5368e5dfb945a85899b4c74f65 upstream.

In case we have a region 1 the following calculation
(31 + ((gmap->asce & _ASCE_TYPE_MASK) >> 2)*11)
results in 64. As shifts beyond the size are undefined the compiler is
free to use instructions like sllg. sllg will only use 6 bits of the
shift value (here 64) resulting in no shift at all. That means that ALL
addresses will be rejected.

The can result in endless loops, e.g. when prefix cannot get mapped.

Fixes: 4be130a08420 ("s390/mm: add shadow gmap support")
Tested-by: Janosch Frank <frankja@linux.ibm.com>
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200403153050.20569-2-david@redhat.com
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
[borntraeger@de.ibm.com: fix patch description, remove WARN_ON_ONCE]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/gmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -787,14 +787,18 @@ static void gmap_call_notifier(struct gm
 static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 					     unsigned long gaddr, int level)
 {
+	const int asce_type = gmap->asce & _ASCE_TYPE_MASK;
 	unsigned long *table;
 
 	if ((gmap->asce & _ASCE_TYPE_MASK) + 4 < (level * 4))
 		return NULL;
 	if (gmap_is_shadow(gmap) && gmap->removed)
 		return NULL;
-	if (gaddr & (-1UL << (31 + ((gmap->asce & _ASCE_TYPE_MASK) >> 2)*11)))
+
+	if (asce_type != _ASCE_TYPE_REGION1 &&
+	    gaddr & (-1UL << (31 + (asce_type >> 2) * 11)))
 		return NULL;
+
 	table = gmap->table;
 	switch (gmap->asce & _ASCE_TYPE_MASK) {
 	case _ASCE_TYPE_REGION1:


