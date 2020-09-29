Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBA27C94C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbgI2MJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730205AbgI2Lhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87EE23A40;
        Tue, 29 Sep 2020 11:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378557;
        bh=jE3e13qSpJMENANMV8jXxE2G5zeQxR+Lw9XEoDM/qEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XYhKQSjd00ktkrsq5v6ECfZmIdlzfCSe5AnfTMFbvCat9fOrn4QIOgmdLjGSp8SG
         aUi9lNfI+2PgdoGG4+YEUGiP6MmyRLdbdNxaU34QI/vs8VkDX+YegrBlK+raYURA1E
         yUrkpOppbvjoWRzA3aR2umwnqPnCLupPm9sSK99A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/245] s390/cpum_sf: Use kzalloc and minor changes
Date:   Tue, 29 Sep 2020 12:58:28 +0200
Message-Id: <20200929105949.771440541@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 32dab6828c42f087439d3e2617dc7283546bd8f7 ]

Use kzalloc() to allocate auxiliary buffer structure initialized
with all zeroes to avoid random value in trace output.

Avoid double access to SBD hardware flags.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 74a296cea21cc..0e6d01225a670 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1377,8 +1377,8 @@ static int aux_output_begin(struct perf_output_handle *handle,
 		idx = aux->empty_mark + 1;
 		for (i = 0; i < range_scan; i++, idx++) {
 			te = aux_sdb_trailer(aux, idx);
-			te->flags = te->flags & ~SDB_TE_BUFFER_FULL_MASK;
-			te->flags = te->flags & ~SDB_TE_ALERT_REQ_MASK;
+			te->flags &= ~(SDB_TE_BUFFER_FULL_MASK |
+				       SDB_TE_ALERT_REQ_MASK);
 			te->overflow = 0;
 		}
 		/* Save the position of empty SDBs */
@@ -1425,8 +1425,7 @@ static bool aux_set_alert(struct aux_buffer *aux, unsigned long alert_index,
 	te = aux_sdb_trailer(aux, alert_index);
 	do {
 		orig_flags = te->flags;
-		orig_overflow = te->overflow;
-		*overflow = orig_overflow;
+		*overflow = orig_overflow = te->overflow;
 		if (orig_flags & SDB_TE_BUFFER_FULL_MASK) {
 			/*
 			 * SDB is already set by hardware.
@@ -1660,7 +1659,7 @@ static void *aux_buffer_setup(struct perf_event *event, void **pages,
 	}
 
 	/* Allocate aux_buffer struct for the event */
-	aux = kmalloc(sizeof(struct aux_buffer), GFP_KERNEL);
+	aux = kzalloc(sizeof(struct aux_buffer), GFP_KERNEL);
 	if (!aux)
 		goto no_aux;
 	sfb = &aux->sfb;
-- 
2.25.1



