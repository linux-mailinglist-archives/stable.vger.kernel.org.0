Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4523ADB5
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 05:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbfFJDpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 23:45:14 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:24926 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387457AbfFJDpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 23:45:13 -0400
X-UUID: b2bb53f8932f442ca9a3f478ae319eea-20190610
X-UUID: b2bb53f8932f442ca9a3f478ae319eea-20190610
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <weiyi.lu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 740195698; Mon, 10 Jun 2019 11:44:56 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 10 Jun 2019 11:44:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 10 Jun 2019 11:44:55 +0800
From:   Weiyi Lu <weiyi.lu@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>
CC:     James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-clk@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Biao Huang <biao.huang@mediatek.com>
Subject: [RFC v1] clk: core: support clocks that need to be enabled during re-parent
Date:   Mon, 10 Jun 2019 11:44:53 +0800
Message-ID: <1560138293-4163-1-git-send-email-weiyi.lu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When using property assigned-clock-parents to assign parent clocks,
core clocks might still be disabled during re-parent.
Add flag 'CLK_OPS_CORE_ENABLE' for those clocks must be enabled
during re-parent.

Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
---
 drivers/clk/clk.c            | 9 +++++++++
 include/linux/clk-provider.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 443711f..b2e6fe3 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1717,6 +1717,10 @@ static struct clk_core *__clk_set_parent_before(struct clk_core *core,
 		clk_core_prepare_enable(parent);
 	}
 
+	/* enable core if CLK_OPS_CORE_ENABLE is set */
+	if (core->flags & CLK_OPS_CORE_ENABLE)
+		clk_core_prepare_enable(core);
+
 	/* migrate prepare count if > 0 */
 	if (core->prepare_count) {
 		clk_core_prepare_enable(parent);
@@ -1744,6 +1748,10 @@ static void __clk_set_parent_after(struct clk_core *core,
 		clk_core_disable_unprepare(old_parent);
 	}
 
+	/* re-balance ref counting if CLK_OPS_CORE_ENABLE is set */
+	if (core->flags & CLK_OPS_CORE_ENABLE)
+		clk_core_disable_unprepare(core);
+
 	/* re-balance ref counting if CLK_OPS_PARENT_ENABLE is set */
 	if (core->flags & CLK_OPS_PARENT_ENABLE) {
 		clk_core_disable_unprepare(parent);
@@ -2973,6 +2981,7 @@ static int clk_dump_show(struct seq_file *s, void *data)
 	ENTRY(CLK_IS_CRITICAL),
 	ENTRY(CLK_OPS_PARENT_ENABLE),
 	ENTRY(CLK_DUTY_CYCLE_PARENT),
+	ENTRY(CLK_OPS_CORE_ENABLE),
 #undef ENTRY
 };
 
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index bb6118f..39a1fed 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -34,6 +34,7 @@
 #define CLK_OPS_PARENT_ENABLE	BIT(12)
 /* duty cycle call may be forwarded to the parent clock */
 #define CLK_DUTY_CYCLE_PARENT	BIT(13)
+#define CLK_OPS_CORE_ENABLE	BIT(14)	/* core need enable during re-parent */
 
 struct clk;
 struct clk_hw;
-- 
1.8.1.1.dirty

