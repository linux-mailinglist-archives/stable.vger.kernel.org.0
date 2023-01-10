Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71BF664AE7
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239424AbjAJShh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239484AbjAJSgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:36:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A61D96104
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3297E61852
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E57BC433EF;
        Tue, 10 Jan 2023 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375515;
        bh=xbv9mDpcDrHE+3MaMvq7hoVRF/3NzkaZCOxsgp8lXiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vstFL0lK5fDLlJTH4qhdNQWvCegPVBLWq6dugqmlbW1Iq1lL7fHBT7Y4scp2jQeJP
         YZICoh790ITFyi4ll/US5obZ0p55ZeePcbfHXyl0wpAtRq4WR39jodXqg5Nudbbr12
         GLhWZsb0vQS7jjkeYN6Cy+zc5cJ8WBGHPHPxO45I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Johnny S. Lee" <foss@jsl.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/290] net: dsa: mv88e6xxx: depend on PTP conditionally
Date:   Tue, 10 Jan 2023 19:05:07 +0100
Message-Id: <20230110180039.419353363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Johnny S. Lee <foss@jsl.io>

[ Upstream commit 30e725537546248bddc12eaac2fe0a258917f190 ]

PTP hardware timestamping related objects are not linked when PTP
support for MV88E6xxx (NET_DSA_MV88E6XXX_PTP) is disabled, therefore
NET_DSA_MV88E6XXX should not depend on PTP_1588_CLOCK_OPTIONAL
regardless of NET_DSA_MV88E6XXX_PTP.

Instead, condition more strictly on how NET_DSA_MV88E6XXX_PTP's
dependencies are met, making sure that it cannot be enabled when
NET_DSA_MV88E6XXX=y and PTP_1588_CLOCK=m.

In other words, this commit allows NET_DSA_MV88E6XXX to be built-in
while PTP_1588_CLOCK is a module, as long as NET_DSA_MV88E6XXX_PTP is
prevented from being enabled.

Fixes: e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
Signed-off-by: Johnny S. Lee <foss@jsl.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 7a2445a34eb7..e3181d5471df 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -2,7 +2,6 @@
 config NET_DSA_MV88E6XXX
 	tristate "Marvell 88E6xxx Ethernet switch fabric support"
 	depends on NET_DSA
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select IRQ_DOMAIN
 	select NET_DSA_TAG_EDSA
 	select NET_DSA_TAG_DSA
@@ -13,7 +12,8 @@ config NET_DSA_MV88E6XXX
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on NET_DSA_MV88E6XXX && PTP_1588_CLOCK
+	depends on (NET_DSA_MV88E6XXX = y && PTP_1588_CLOCK = y) || \
+	           (NET_DSA_MV88E6XXX = m && PTP_1588_CLOCK)
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
-- 
2.35.1



