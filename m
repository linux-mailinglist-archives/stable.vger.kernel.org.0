Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5906D37CC25
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhELQnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242459AbhELQev (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B53161956;
        Wed, 12 May 2021 15:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835176;
        bh=Sqj3YWST87hmXhuhOXg2T/RXQkYW65pVPk0SVR/NFjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRRjW3TxSyT+LW2C/yA3MZpHZlajo9doegEKZ9NlhFF0Ss0VSdBeMla65AguQAyY3
         J1yyjWMGRPk7/+8wTLf11+KELMFrqL9clF0aMHbJEuKnikgT9/KgUMUKwbylA4Vuso
         mNm2suXJVV5ymrEJg97zFsT3dgnKTPZ2jr5RriqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 239/677] phy: ti: j721e-wiz: Delete "clk_div_sel" clk provider during cleanup
Date:   Wed, 12 May 2021 16:44:45 +0200
Message-Id: <20210512144845.178280949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 7e52a39f1942b771213678c56002ce90a2f126d2 ]

commit 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module
present in TI J721E SoC") modeled both MUX clocks and DIVIDER clocks in
wiz. However during cleanup, it removed only the MUX clock provider.
Remove the DIVIDER clock provider here.

Fixes: 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module present in TI J721E SoC")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20210310120840.16447-3-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index a75433b459dd..e28e25f98708 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -615,6 +615,12 @@ static void wiz_clock_cleanup(struct wiz *wiz, struct device_node *node)
 		of_clk_del_provider(clk_node);
 		of_node_put(clk_node);
 	}
+
+	for (i = 0; i < wiz->clk_div_sel_num; i++) {
+		clk_node = of_get_child_by_name(node, clk_div_sel[i].node_name);
+		of_clk_del_provider(clk_node);
+		of_node_put(clk_node);
+	}
 }
 
 static int wiz_clock_init(struct wiz *wiz, struct device_node *node)
-- 
2.30.2



