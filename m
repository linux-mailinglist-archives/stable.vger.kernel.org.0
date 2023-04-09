Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456E16DBE53
	for <lists+stable@lfdr.de>; Sun,  9 Apr 2023 04:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjDICqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 22:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDICqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 22:46:39 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D4C5B95;
        Sat,  8 Apr 2023 19:46:32 -0700 (PDT)
X-UUID: b8d2775cd68011eda9a90f0bb45854f4-20230409
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=RT6t6k0uRnv8KRrBTo9piwxXohY+DCmlYMyknmWtfNY=;
        b=XlJT9ba5DtASdgzl0yqtzF/plWLN4TQikNU5tYUbcABPolQ5egdmArdBqwZIHvlK2EsoWekcjsTTC0adODFBSrPwRi+5abfhQmB54+hu39rNJWR7seMOmcSXtI8kbAmOtUxpxKbT6NGpsmeTUynfycl0Sr67qftoDmnsQIkgxmU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:0072c493-e98d-4941-995d-dd8cc0cc4503,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:120426c,CLOUDID:5ac19eb5-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: b8d2775cd68011eda9a90f0bb45854f4-20230409
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1597067467; Sun, 09 Apr 2023 10:46:26 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sun, 9 Apr 2023 10:46:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Sun, 9 Apr 2023 10:46:24 +0800
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
Subject: [PATCH v2] ring-buffer: Prevent inconsistent operation on cpu_buffer->resize_disabled
Date:   Sun, 9 Apr 2023 10:46:15 +0800
Message-ID: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
References: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Write to buffer_size_kb can permanently fail due to cpu_online_mask changed
between two for_each_online_buffer_cpu loops.
The number of increasing and decreasing on cpu_buffer->resize_disable
may be inconsistent, leading that the resize_disabled in some CPUs
becoming none zero after ring_buffer_reset_online_cpus return.

This issue can be reproduced by "echo 0 > trace" and hotplug cpu at the
same time. After reproducing success, we can find out buffer_size_kb
will not be functional anymore.

This patch uses cpus_read_lock() to prevent cpu_online_mask being changed
between two different "for_each_online_buffer_cpu".

Changes in v2:
  Use cpus_read_lock() instead of copying cpu_online_mask at the entry of
  function

Link:
  https://lore.kernel.org/lkml/20230408052226.25268-1-Tze-nan.Wu@mediatek.com/

Cc: stable@vger.kernel.org
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
---
 kernel/trace/ring_buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 76a2d91eecad..44d833252fb0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5357,6 +5357,7 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 
 	/* prevent another thread from changing buffer sizes */
 	mutex_lock(&buffer->mutex);
+	cpus_read_lock();
 
 	for_each_online_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
@@ -5377,6 +5378,7 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
 
+	cpus_read_unlock();
 	mutex_unlock(&buffer->mutex);
 }
 
-- 
2.18.0

