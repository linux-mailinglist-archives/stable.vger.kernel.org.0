Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0886126EB19
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgIRCDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbgIRCDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD7F21973;
        Fri, 18 Sep 2020 02:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394591;
        bh=FyTZiqyP+z3Jchr1b9Ht22bUzYBfvQx5LLExmT3Xiqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjuaiFQNA4ZeJposfeEpWyAJPwDl/96vr8HIkSmyA77hP/sewPKZnNMrAXbTg8gvk
         x0DSmj0oTlSVLayQp2PWAgmwNKrkjM/7VmqBnxCRZkjY9XtoJnBdjftG+h3FGOQB2/
         9ywcf3X8dFkGd8ZD5s++cfj5N02XR65NSr8f9VdU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 099/330] s390/cpum_sf: Use kzalloc and minor changes
Date:   Thu, 17 Sep 2020 21:57:19 -0400
Message-Id: <20200918020110.2063155-99-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 229e1e2f8253a..996e447ead3a6 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1429,8 +1429,8 @@ static int aux_output_begin(struct perf_output_handle *handle,
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
@@ -1477,8 +1477,7 @@ static bool aux_set_alert(struct aux_buffer *aux, unsigned long alert_index,
 	te = aux_sdb_trailer(aux, alert_index);
 	do {
 		orig_flags = te->flags;
-		orig_overflow = te->overflow;
-		*overflow = orig_overflow;
+		*overflow = orig_overflow = te->overflow;
 		if (orig_flags & SDB_TE_BUFFER_FULL_MASK) {
 			/*
 			 * SDB is already set by hardware.
@@ -1712,7 +1711,7 @@ static void *aux_buffer_setup(struct perf_event *event, void **pages,
 	}
 
 	/* Allocate aux_buffer struct for the event */
-	aux = kmalloc(sizeof(struct aux_buffer), GFP_KERNEL);
+	aux = kzalloc(sizeof(struct aux_buffer), GFP_KERNEL);
 	if (!aux)
 		goto no_aux;
 	sfb = &aux->sfb;
-- 
2.25.1

