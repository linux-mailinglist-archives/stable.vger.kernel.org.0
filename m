Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB286D4A75
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbjDCOrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbjDCOq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D5F29BC2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 978DE61F3D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AFDC4339B;
        Mon,  3 Apr 2023 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533195;
        bh=3InTRFTtLxRXa6fB+PRh4MmRPgIdzP5bbhdupcIPUwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIdPFBCQ/5jyyTomGMJEiNiEuut4hC0Fx54cEqoefprZRvAKsqYd7smrtcGX3JNxa
         N/sx5AX14Ut1HoSJhQ/u3ClSV44Mg8AXaiOpEXPo44WLf3bhsL8jjpa6PEFpRo/OBx
         irFZDkFTvpJTrtj2ULawnFRlkCeOXbtQMFboVZvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 083/187] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
Date:   Mon,  3 Apr 2023 16:08:48 +0200
Message-Id: <20230403140418.694383414@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 88e943e83827a349f70c3464b3eba7260be7461d ]

Before this patch, the ksz8_fdb_dump() function had several issues, such
as uninitialized variables and incorrect usage of source port as a bit
mask. These problems caused inaccurate reporting of vid information and
port assignment in the bridge fdb.

Fixes: e587be759e6e ("net: dsa: microchip: update fdb add/del/dump in ksz_common")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 003b0ac2854c9..3fffd5da8d3b0 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -958,15 +958,14 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	u16 entries = 0;
 	u8 timestamp = 0;
 	u8 fid;
-	u8 member;
-	struct alu_struct alu;
+	u8 src_port;
+	u8 mac[ETH_ALEN];
 
 	do {
-		alu.is_static = false;
-		ret = ksz8_r_dyn_mac_table(dev, i, alu.mac, &fid, &member,
+		ret = ksz8_r_dyn_mac_table(dev, i, mac, &fid, &src_port,
 					   &timestamp, &entries);
-		if (!ret && (member & BIT(port))) {
-			ret = cb(alu.mac, alu.fid, alu.is_static, data);
+		if (!ret && port == src_port) {
+			ret = cb(mac, fid, false, data);
 			if (ret)
 				break;
 		}
-- 
2.39.2



