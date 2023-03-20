Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81CF6C1910
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjCTPaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjCTP3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:29:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23D9C678
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B8A0CE12EF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A516C433D2;
        Mon, 20 Mar 2023 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325731;
        bh=4AVLU78PKiAjpzcJawbcdu3hsuRz4FfSa0DymU9gJkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXWIATtuQSCKZfSHn/iIycnS8rzozHbD0DBdyP1DPcSnMgiGVttjGHxWSI+yGNWDI
         graET7piCgby1IZ1Ui4xEDYFvWAYJZdg2e7mAO4KUdWoDdsa9MxA/IR5n//sfeeVZY
         4fpqW9Sb13AwA6GDhzvkWlxGI1zEXl6QYv/oALdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 092/211] net: dsa: microchip: fix RGMII delay configuration on KSZ8765/KSZ8794/KSZ8795
Date:   Mon, 20 Mar 2023 15:53:47 +0100
Message-Id: <20230320145517.151476176@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 5ae06327a3a5bad4ee246d81df203b1b00a7b390 ]

The blamed commit has replaced a ksz_write8() call to address
REG_PORT_5_CTRL_6 (0x56) with a ksz_set_xmii() -> ksz_pwrite8() call to
regs[P_XMII_CTRL_1], which is also defined as 0x56 for ksz8795_regs[].

The trouble is that, when compared to ksz_write8(), ksz_pwrite8() also
adjusts the register offset with the port base address. So in reality,
ksz_pwrite8(offset=0x56) accesses register 0x56 + 0x50 = 0xa6, which in
this switch appears to be unmapped, and the RGMII delay configuration on
the CPU port does nothing.

So if the switch wasn't fine with the RGMII delay configuration done
through pin strapping and relied on Linux to apply a different one in
order to pass traffic, this is now broken.

Using the offset translation logic imposed by ksz_pwrite8(), the correct
value for regs[P_XMII_CTRL_1] should have been 0x6 on ksz8795_regs[], in
order to really end up accessing register 0x56.

Static code analysis shows that, despite there being multiple other
accesses to regs[P_XMII_CTRL_1] in this driver, the only code path that
is applicable to ksz8795_regs[] and ksz8_dev_ops is ksz_set_xmii().
Therefore, the problem is isolated to RGMII delays.

In its current form, ksz8795_regs[] contains the same value for
P_XMII_CTRL_0 and for P_XMII_CTRL_1, and this raises valid suspicions
that writes made by the driver to regs[P_XMII_CTRL_0] might overwrite
writes made to regs[P_XMII_CTRL_1] or vice versa.

Again, static analysis shows that the only accesses to P_XMII_CTRL_0
from the driver are made from code paths which are not reachable with
ksz8_dev_ops. So the accesses made by ksz_set_xmii() are safe for this
switch family.

[ vladimiroltean: rewrote commit message ]

Fixes: c476bede4b0f ("net: dsa: microchip: ksz8795: use common xmii function")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230315231916.2998480-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9b20c2ee6d62a..19cd05762ab77 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -310,7 +310,7 @@ static const u16 ksz8795_regs[] = {
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
 	[P_XMII_CTRL_0]			= 0x06,
-	[P_XMII_CTRL_1]			= 0x56,
+	[P_XMII_CTRL_1]			= 0x06,
 };
 
 static const u32 ksz8795_masks[] = {
-- 
2.39.2



