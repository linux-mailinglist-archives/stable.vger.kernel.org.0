Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8529AEA04F
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfJ3PzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728570AbfJ3PzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:55:22 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAC7217D9;
        Wed, 30 Oct 2019 15:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450922;
        bh=qXGTM2oCfxyP+vBtLzKiCjtARCt/2w0XbTT/leTHjvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilxE5FIfSMgGm6S87C1IiPyJNB3soaK6ITJ3eynX5m6w9fHHntKiV6tgiJznUNjej
         iIDPUzYA6v8nifsKkbsxjBLZKNFra5SBPgipgzByJfMN61BCIo7p3uUdmfN2hhYEub
         +nQg/tWuCePTp/llmJS9xxX6o6aMj2OEjeWub+D8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 27/38] tracing: Fix "gfp_t" format for synthetic events
Date:   Wed, 30 Oct 2019 11:53:55 -0400
Message-Id: <20191030155406.10109-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit 9fa8c9c647be624e91b09ecffa7cd97ee0600b40 ]

In the format of synthetic events, the "gfp_t" is shown as "signed:1",
but in fact the "gfp_t" is "unsigned", should be shown as "signed:0".

The issue can be reproduced by the following commands:

echo 'memlatency u64 lat; unsigned int order; gfp_t gfp_flags; int migratetype' > /sys/kernel/debug/tracing/synthetic_events
cat  /sys/kernel/debug/tracing/events/synthetic/memlatency/format

name: memlatency
ID: 2233
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:u64 lat;  offset:8;       size:8; signed:0;
        field:unsigned int order;       offset:16;      size:4; signed:0;
        field:gfp_t gfp_flags;  offset:24;      size:4; signed:1;
        field:int migratetype;  offset:32;      size:4; signed:1;

print fmt: "lat=%llu, order=%u, gfp_flags=%x, migratetype=%d", REC->lat, REC->order, REC->gfp_flags, REC->migratetype

Link: http://lkml.kernel.org/r/20191018012034.6404-1-zhengjun.xing@linux.intel.com

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index bdf104596d122..dac518977e7d0 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -448,6 +448,8 @@ static bool synth_field_signed(char *type)
 {
 	if (strncmp(type, "u", 1) == 0)
 		return false;
+	if (strcmp(type, "gfp_t") == 0)
+		return false;
 
 	return true;
 }
-- 
2.20.1

