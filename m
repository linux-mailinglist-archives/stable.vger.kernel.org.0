Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4868C26F12B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgIRCtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgIRCJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6413623976;
        Fri, 18 Sep 2020 02:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394947;
        bh=jE3e13qSpJMENANMV8jXxE2G5zeQxR+Lw9XEoDM/qEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0IuJg2m9LC8+XqryVRVuhkOG1I2o5qA0TcDm4wiRtZFBRIy4ychGS9JgVHfIeuZ8
         rnuqbhxLvg7wExouHA3zc7jkFa4tmXwHBfEm9oBLqU9X+jSvftW4qHlfzYKAN+EBvj
         4FU/4QXwl56P9bZg3bn3uSnXxDC7z36T6HPN0BB4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 054/206] s390/cpum_sf: Use kzalloc and minor changes
Date:   Thu, 17 Sep 2020 22:05:30 -0400
Message-Id: <20200918020802.2065198-54-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
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

