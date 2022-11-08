Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67806213CB
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbiKHNyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiKHNxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:53:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAED9263B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 592D5B81AA1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CC8C433D6;
        Tue,  8 Nov 2022 13:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915629;
        bh=aZe57rLz+ua5BS5TsalDUvQH8PI9MmG4YqfQXDVjbI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akBVNuW6LQQYUiTVIQSyqkXdjCVkiwIrJhIu9pcVoazcl0ZbyFzoZO5Mgv4OPdd5z
         we6cfmWfQliZctpA+gHVNVFyaqMOBE+AyevPVEgzzbmemKcN/6y6KTg0Q2rR7RJDUb
         4u3d+WaWQLAiO2WmumYz/iqZx9p/NPUj5EgWsWxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/118] net: mdio: fix undefined behavior in bit shift for __mdiobus_register
Date:   Tue,  8 Nov 2022 14:38:42 +0100
Message-Id: <20221108133342.592338870@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 40e4eb324c59e11fcb927aa46742d28aba6ecb8a ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in drivers/net/phy/mdio_bus.c:586:27
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 __mdiobus_register+0x49d/0x4e0
 fixed_mdio_bus_init+0xd8/0x12d
 do_one_initcall+0x76/0x430
 kernel_init_freeable+0x3b3/0x422
 kernel_init+0x24/0x1e0
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: 4fd5f812c23c ("phylib: allow incremental scanning of an mii bus")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221031132645.168421-1-cuigaosheng1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c1cbdac4b376..77ba6c3c7a09 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -574,7 +574,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	}
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-		if ((bus->phy_mask & (1 << i)) == 0) {
+		if ((bus->phy_mask & BIT(i)) == 0) {
 			struct phy_device *phydev;
 
 			phydev = mdiobus_scan(bus, i);
-- 
2.35.1



