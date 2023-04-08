Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B616DB90C
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 07:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjDHFWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 01:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDHFWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 01:22:48 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9837BBDD2;
        Fri,  7 Apr 2023 22:22:42 -0700 (PDT)
X-UUID: 5ecb7e56d5cd11edb6b9f13eb10bd0fe-20230408
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Wdlz1937eg98NYAB81abic14zLCB/RzHOwbInQ9humY=;
        b=hvQJikB/1Nc8NvLlEUZJGrU4Wf/bXW/yOpA9LCkozheJr5PaNqhiMq/T/s33dgCivmbmoIyZTGk+s5dWU7lF8nzqJ4tDfHPS8Y+R+rjF6mzywjk1UdjRY2Nw6H6x1xQEV5mF3yqywN9y1A+mDN+xSydamZGgxv0sJbJ4KJTfFFA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:42bf6f06-109c-45ce-a628-11ce0c3c0bc7,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Release_Ham,ACT
        ION:release,TS:75
X-CID-INFO: VERSION:1.1.22,REQID:42bf6f06-109c-45ce-a628-11ce0c3c0bc7,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACT
        ION:quarantine,TS:75
X-CID-META: VersionHash:120426c,CLOUDID:ad781ff8-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:230408132236CR9EZPQB,BulkQuantity:0,Recheck:0,SF:29|28|17|19|48|38,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
        ,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 5ecb7e56d5cd11edb6b9f13eb10bd0fe-20230408
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 84322464; Sat, 08 Apr 2023 13:22:35 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sat, 8 Apr 2023 13:22:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Sat, 8 Apr 2023 13:22:34 +0800
From:   Tze-nan Wu <Tze-nan.Wu@mediatek.com>
To:     <rostedt@goodmis.org>, <mhiramat@kernel.org>
CC:     <bobule.chang@mediatek.com>, <wsd_upstream@mediatek.com>,
        <Tze-nan.Wu@mediatek.com>, <stable@vger.kernel.org>,
        "AngeloGioacchino Del Regno" 
        <angelogioacchino.delregno@collabora.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH] ring-buffer: Prevent inconsistent operation on cpu_buffer->resize_disabled
Date:   Sat, 8 Apr 2023 13:22:26 +0800
Message-ID: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,RDNS_NONE,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sometimes, write to buffer_size_kb can be permanently failure if we change
the cpu_online_mask between two for_each_online_buffer_cpu loops in
function ring_buffer_reset_online_cpus.

The number of increasing and decreasing on cpu_buffer->resize_disable
may be inconsistent, leading the resize_disabled in some CPUs becoming
none zero after ring_buffer_reset_online_cpus return.

This issue can be reproduced by "echo 0 > trace" and hotplug cpu at the
same time. After reproducing succeess, we can find out the attempt to
write to buffer_size_kb node failure every time.

This patch prevent the inconsistent increasing and decreasing on
cpu_buffer->resize_disabled by copying the cpu_online_mask at the
beginning of the function.

But I wonder if there's any side-effect of this patch,
since the behavior changed, if we turn on a cpu between the two loops,
reset_disabled_cpu_buffer() of that cpu won't be run as before,
meaning the cpu_buffer on that cpu just awake will not be cleaned up.

Cc: stable@vger.kernel.org
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
---
 kernel/trace/ring_buffer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 76a2d91eecad..468f46bba71e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -288,9 +288,6 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define for_each_buffer_cpu(buffer, cpu)		\
 	for_each_cpu(cpu, buffer->cpumask)
 
-#define for_each_online_buffer_cpu(buffer, cpu)		\
-	for_each_cpu_and(cpu, buffer->cpumask, cpu_online_mask)
-
 #define TS_SHIFT	27
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
 #define TS_DELTA_TEST	(~TS_MASK)
@@ -5353,12 +5350,15 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	cpumask_var_t reset_online_mask;
 	int cpu;
 
 	/* prevent another thread from changing buffer sizes */
 	mutex_lock(&buffer->mutex);
 
-	for_each_online_buffer_cpu(buffer, cpu) {
+	cpumask_copy(reset_online_mask, cpu_online_mask);
+
+	for_each_cpu_and(cpu, buffer->cpumask, reset_online_mask) {
 		cpu_buffer = buffer->buffers[cpu];
 
 		atomic_inc(&cpu_buffer->resize_disabled);
@@ -5368,7 +5368,7 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 	/* Make sure all commits have finished */
 	synchronize_rcu();
 
-	for_each_online_buffer_cpu(buffer, cpu) {
+	for_each_cpu_and(cpu, buffer->cpumask, reset_online_mask) {
 		cpu_buffer = buffer->buffers[cpu];
 
 		reset_disabled_cpu_buffer(cpu_buffer);
-- 
2.18.0

