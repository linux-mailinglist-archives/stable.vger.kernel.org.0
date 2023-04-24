Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2746ECE5F
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjDXNbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbjDXNbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEEA7D8A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B33162336
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBF6C433D2;
        Mon, 24 Apr 2023 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343064;
        bh=ecAMf6qGg+IApvGm14X8LPM1kVNrVNVx6A9l323fbKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mm29vvlJVPtE23vltfyRe2xyQ+3mIJQkhZytu2xz7SHPWOslGV+oZ9Ibp4AJRi2H6
         uCNCvAVTaKwUam7OlMZ5sgqJeP2fbqiT1b0qU1fu9ZPQvNpkWJ0JWfWnDBCaxYXKuq
         MiIYWFXgSidMiRtmj0wmQVz559IPtyzpdwsunyUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Simon Horman <simon.horman@corigine.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 034/110] net: dsa: microchip: ksz8795: Correctly handle huge frame configuration
Date:   Mon, 24 Apr 2023 15:16:56 +0200
Message-Id: <20230424131137.427880445@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3d2f8f1f184c60508f7af3022536651d7ac2dd07 ]

Because of the logic in place, SW_HUGE_PACKET can never be set.
(If the first condition is true, then the 2nd one is also true, but is not
executed)

Change the logic and update each bit individually.

Fixes: 29d1e85f45e0 ("net: dsa: microchip: ksz8: add MTU configuration support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 3fffd5da8d3b0..ffcad057d0650 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -96,7 +96,7 @@ static int ksz8795_change_mtu(struct ksz_device *dev, int frame_size)
 
 	if (frame_size > KSZ8_LEGAL_PACKET_SIZE)
 		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
-	else if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
+	if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
 		ctrl1 |= SW_HUGE_PACKET;
 
 	ret = ksz_rmw8(dev, REG_SW_CTRL_1, SW_HUGE_PACKET, ctrl1);
-- 
2.39.2



