Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D91F6DC3E1
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 09:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDJHfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 03:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDJHfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 03:35:45 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E936A2708;
        Mon, 10 Apr 2023 00:35:40 -0700 (PDT)
X-UUID: 47d0307ed77211edb6b9f13eb10bd0fe-20230410
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=7uzc4Gmc54T760tvEhSz8TdAybgvY+nHPJ6ttMqGCTg=;
        b=OebQoBXaTyU94lHq2McKOGd08J4KFwMjblE9k3waiuqevD1fLF2Hd2mTOE/yxC5WZ8iosXPh19m2PXc5U97ICcFRnRGUExGOE537QMfQ8KCzsd0f9Yyevg+BDZ0sMzKkVLgFXmDSatzxWTciECmZZQ7txKIU0DcklVh/SBEvhTY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:5ef009e6-f3bb-4b24-a4a5-5bf4026b70c4,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:120426c,CLOUDID:a90abab5-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 47d0307ed77211edb6b9f13eb10bd0fe-20230410
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 331443076; Mon, 10 Apr 2023 15:35:34 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 10 Apr 2023 15:35:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Mon, 10 Apr 2023 15:35:34 +0800
From:   Tze-nan Wu <Tze-nan.Wu@mediatek.com>
To:     <rostedt@goodmis.org>, <mhiramat@kernel.org>
CC:     <bobule.chang@mediatek.com>, <wsd_upstream@mediatek.com>,
        <Tze-nan.Wu@mediatek.com>, <cheng-jui.wang@mediatek.com>,
        <npiggin@gmail.com>, <stable@vger.kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH v3] ring-buffer: Prevent inconsistent operation on cpu_buffer->resize_disabled
Date:   Mon, 10 Apr 2023 15:35:08 +0800
Message-ID: <20230410073512.13362-1-Tze-nan.Wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
References: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Write to buffer_size_kb can permanently fail, due to cpu_online_mask may
changed between two for_each_online_buffer_cpu loops.
The number of increasing and decreasing on cpu_buffer->resize_disable
may be inconsistent, leading that the resize_disabled in some CPUs
becoming none zero after ring_buffer_reset_online_cpus return.

This issue can be reproduced by "echo 0 > trace" while hotplugging cpu.
After reproducing success, we can find out buffer_size_kb will not be
functional anymore.

Prevent the two "loops" in this function from iterating through different
online cpus by copying cpu_online_mask at the entry of the function.

Changes from v1 to v3:
  Declare the cpumask variable statically rather than dynamically.

Changes from v2 to v3:
  Considering holding cpu_hotplug_lock too long because of the
  synchronize_rcu(), maybe it's better to prevent the issue by copying
  cpu_online_mask at the entry of the function as V1 does, instead of
  using cpus_read_lock().

Link: https://lore.kernel.org/lkml/20230408052226.25268-1-Tze-nan.Wu@mediatek.com/
Link: https://lore.kernel.org/oe-kbuild-all/202304082051.Dp50upfS-lkp@intel.com/
Link: https://lore.kernel.org/oe-kbuild-all/202304081615.eiaqpbV8-lkp@intel.com/

Cc: stable@vger.kernel.org
Cc: npiggin@gmail.com
Fixes: b23d7a5f4a07 ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
---
 kernel/trace/ring_buffer.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 76a2d91eecad..dc758930dacb 100644
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
@@ -5353,12 +5350,19 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	cpumask_t reset_online_cpumask;
 	int cpu;
 
+	/*
+	 * Record cpu_online_mask here to make sure we iterate through the same
+	 * online CPUs in the following two loops.
+	 */
+	cpumask_copy(&reset_online_cpumask, cpu_online_mask);
+
 	/* prevent another thread from changing buffer sizes */
 	mutex_lock(&buffer->mutex);
 
-	for_each_online_buffer_cpu(buffer, cpu) {
+	for_each_cpu_and(cpu, buffer->cpumask, &reset_online_cpumask) {
 		cpu_buffer = buffer->buffers[cpu];
 
 		atomic_inc(&cpu_buffer->resize_disabled);
@@ -5368,7 +5372,7 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 	/* Make sure all commits have finished */
 	synchronize_rcu();
 
-	for_each_online_buffer_cpu(buffer, cpu) {
+	for_each_cpu_and(cpu, buffer->cpumask, &reset_online_cpumask) {
 		cpu_buffer = buffer->buffers[cpu];
 
 		reset_disabled_cpu_buffer(cpu_buffer);
-- 
2.18.0

