Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC74647AF38
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbhLTPKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbhLTPJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB14C061378;
        Mon, 20 Dec 2021 06:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E3366118E;
        Mon, 20 Dec 2021 14:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526A4C36AE7;
        Mon, 20 Dec 2021 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012083;
        bh=cnj5qwstsNGIF8pugNzfTNmYIm4+7WNxtMVij54YhhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFrjF3f/7T+K4MZdU0f3NnGUSuO4VIinWKY1x+hViYX+eca9++ZrX926zEktIlGNy
         H5ZCDCeUCv3tm95wIMIlbpjBQJLCL4BjkDnLAE2Qdm9+5RwSMooUsd+4+2uNQg3mNO
         OU+GnKmB5Bvth6PiNlCbZu3qMmOhbsJvHPNvFK4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/177] net: dsa: mv88e6xxx: Unforce speed & duplex in mac_link_down()
Date:   Mon, 20 Dec 2021 15:33:45 +0100
Message-Id: <20211220143042.630358883@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 9d591fc028b6bddb38c6585874f331267cbdadae ]

Commit 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings
in mac_config") removed forcing of speed and duplex from
mv88e6xxx_mac_config(), where the link is forced down, and left it only
in mv88e6xxx_mac_link_up(), by which time link is unforced.

It seems that (at least on 88E6190) when changing cmode to 2500base-x,
if the link is not forced down, but the speed or duplex are still
forced, the forcing of new settings for speed & duplex doesn't take in
mv88e6xxx_mac_link_up().

Fix this by unforcing speed & duplex in mv88e6xxx_mac_link_down().

Fixes: 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings in mac_config")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index a31cc0ab7c625..43d126628610b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -769,6 +769,10 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
 	     mode == MLO_AN_FIXED) && ops->port_sync_link)
 		err = ops->port_sync_link(chip, port, mode, false);
+
+	if (!err && ops->port_set_speed_duplex)
+		err = ops->port_set_speed_duplex(chip, port, SPEED_UNFORCED,
+						 DUPLEX_UNFORCED);
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
-- 
2.33.0



