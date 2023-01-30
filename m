Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE93968104F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbjA3OCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbjA3OCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:02:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FBC10AB3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89AE7B8114D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE53C433EF;
        Mon, 30 Jan 2023 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087318;
        bh=axvQKe13YnMQQ3pm7ZRTxZipZu2ozLBuOLAC+cMDoZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eV2nulTnbv4CfjFG53M2PUu8kblIMtN68h7776Jw/3UDvF0Wmgp/yM1y//t9jkKU8
         PCji3HD6TBV7NyoUSupxskz9GcIwbj/3CDoL6fwcP3atlealhabkXvKTMH96Iq+2TS
         QqBbWhDw5sQZzyR4uaNmHATYC1rzH8+lnFMgrhuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ning Cai <ncai@quicinc.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/313] net: stmmac: enable all safety features by default
Date:   Mon, 30 Jan 2023 14:49:33 +0100
Message-Id: <20230130134343.074169123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit fdfc76a116b5e9d3e98e6c96fe83b42d011d21d4 ]

In the original implementation of dwmac5
commit 8bf993a5877e ("net: stmmac: Add support for DWMAC5 and implement Safety Features")
all safety features were enabled by default.

Later it seems some implementations didn't have support for all the
features, so in
commit 5ac712dcdfef ("net: stmmac: enable platform specific safety features")
the safety_feat_cfg structure was added to the callback and defined for
some platforms to selectively enable these safety features.

The problem is that only certain platforms were given that software
support. If the automotive safety package bit is set in the hardware
features register the safety feature callback is called for the platform,
and for platforms that didn't get a safety_feat_cfg defined this results
in the following NULL pointer dereference:

[    7.933303] Call trace:
[    7.935812]  dwmac5_safety_feat_config+0x20/0x170 [stmmac]
[    7.941455]  __stmmac_open+0x16c/0x474 [stmmac]
[    7.946117]  stmmac_open+0x38/0x70 [stmmac]
[    7.950414]  __dev_open+0x100/0x1dc
[    7.954006]  __dev_change_flags+0x18c/0x204
[    7.958297]  dev_change_flags+0x24/0x6c
[    7.962237]  do_setlink+0x2b8/0xfa4
[    7.965827]  __rtnl_newlink+0x4ec/0x840
[    7.969766]  rtnl_newlink+0x50/0x80
[    7.973353]  rtnetlink_rcv_msg+0x12c/0x374
[    7.977557]  netlink_rcv_skb+0x5c/0x130
[    7.981500]  rtnetlink_rcv+0x18/0x2c
[    7.985172]  netlink_unicast+0x2e8/0x340
[    7.989197]  netlink_sendmsg+0x1a8/0x420
[    7.993222]  ____sys_sendmsg+0x218/0x280
[    7.997249]  ___sys_sendmsg+0xac/0x100
[    8.001103]  __sys_sendmsg+0x84/0xe0
[    8.004776]  __arm64_sys_sendmsg+0x24/0x30
[    8.008983]  invoke_syscall+0x48/0x114
[    8.012840]  el0_svc_common.constprop.0+0xcc/0xec
[    8.017665]  do_el0_svc+0x38/0xb0
[    8.021071]  el0_svc+0x2c/0x84
[    8.024212]  el0t_64_sync_handler+0xf4/0x120
[    8.028598]  el0t_64_sync+0x190/0x194

Go back to the original behavior, if the automotive safety package
is found to be supported in hardware enable all the features unless
safety_feat_cfg is passed in saying this particular platform only
supports a subset of the features.

Fixes: 5ac712dcdfef ("net: stmmac: enable platform specific safety features")
Reported-by: Ning Cai <ncai@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 9c2d40f853ed..413f66017219 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -186,11 +186,25 @@ static void dwmac5_handle_dma_err(struct net_device *ndev,
 int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp,
 			      struct stmmac_safety_feature_cfg *safety_feat_cfg)
 {
+	struct stmmac_safety_feature_cfg all_safety_feats = {
+		.tsoee = 1,
+		.mrxpee = 1,
+		.mestee = 1,
+		.mrxee = 1,
+		.mtxee = 1,
+		.epsi = 1,
+		.edpp = 1,
+		.prtyen = 1,
+		.tmouten = 1,
+	};
 	u32 value;
 
 	if (!asp)
 		return -EINVAL;
 
+	if (!safety_feat_cfg)
+		safety_feat_cfg = &all_safety_feats;
+
 	/* 1. Enable Safety Features */
 	value = readl(ioaddr + MTL_ECC_CONTROL);
 	value |= MEEAO; /* MTL ECC Error Addr Status Override */
-- 
2.39.0



