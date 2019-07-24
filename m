Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD6B7399C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390277AbfGXTlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390275AbfGXTly (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E86422ADF;
        Wed, 24 Jul 2019 19:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997313;
        bh=PNUA8Ka9IUNfHS8qrDuTKuvL0ktXVNN/bP8sKm1opR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn8ouz5tWsotXikrbGiIVGx8Oc2lxNw2J1n0kJHgYXQvmjyYJUAT+rr3368fQ14rq
         Rsuolym0aj96HaaAtGqmiz67SdZAfjtHT47w0z2mpPpQaXWIkn0YC/n4fhUVUHuBwe
         OKs7V21g//IntV8rdGzRUKkamIJZHZudE3xwMXrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 394/413] powerpc/pseries: Fix oops in hotplug memory notifier
Date:   Wed, 24 Jul 2019 21:21:25 +0200
Message-Id: <20190724191803.205970705@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

commit 0aa82c482ab2ece530a6f44897b63b274bb43c8e upstream.

During post-migration device tree updates, we can oops in
pseries_update_drconf_memory() if the source device tree has an
ibm,dynamic-memory-v2 property and the destination has a
ibm,dynamic_memory (v1) property. The notifier processes an "update"
for the ibm,dynamic-memory property but it's really an add in this
scenario. So make sure the old property object is there before
dereferencing it.

Fixes: 2b31e3aec1db ("powerpc/drmem: Add support for ibm, dynamic-memory-v2 property")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/hotplug-memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -976,6 +976,9 @@ static int pseries_update_drconf_memory(
 	if (!memblock_size)
 		return -EINVAL;
 
+	if (!pr->old_prop)
+		return 0;
+
 	p = (__be32 *) pr->old_prop->value;
 	if (!p)
 		return -EINVAL;


