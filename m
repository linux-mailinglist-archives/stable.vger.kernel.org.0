Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4FD6D49A4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbjDCOj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbjDCOjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:39:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603AE1766E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 107BAB81CDE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FB9C433D2;
        Mon,  3 Apr 2023 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532789;
        bh=M22DJ+mVfTKZWQi6MsRdRD2l2Ixq8iEj5qdp5K6pGXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX4/PuPcEJP3s7BFv+F/MNUvKgLRSaaH10RtiP/ZgPBtaUZOS9F1RLoFJRS310/5i
         eZkYjOYzrsgXuu8Qb+bWOWuTLYUO06Cmg619n6I9VNTQE3FIwCj7Ym93dYIHqwo+7j
         XYfHjRpo1SwxYhqTJyfyYrb2OklxC14tkIzDnXvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/181] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
Date:   Mon,  3 Apr 2023 16:08:42 +0200
Message-Id: <20230403140417.948373548@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index bd3b133e7085b..22250ae222b5b 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -907,15 +907,14 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
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



