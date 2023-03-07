Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7B56AF483
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbjCGTRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbjCGTQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7743CCDA12
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 003A761518
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9E1C4339E;
        Tue,  7 Mar 2023 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215610;
        bh=ANdK5IJ9kk3EqkVoXOEZKwN6xWuAs/n5AGH+PEsKTJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhwBSXO2m+TFfFfuhiPlknfJWVqlXPWbyRcFKNqCfM/5DE2qrGmIo3PjvUU2DNB35
         zdab4Iuq5Q61+rlbfgofjIMTknqR0G5pfdSelTLV8XMED16a/dCMjHJH+8I+2YK1up
         7TBK0/QMJo07Y/OCnptSJS7lHfxv87cybfv81lzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/567] usb: musb: mediatek: dont unregister something that wasnt registered
Date:   Tue,  7 Mar 2023 18:00:53 +0100
Message-Id: <20230307165919.604558768@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit ba883de971d1ad018f3083d9195b8abe54d87407 ]

This function only calls mtk_otg_switch_init() when the ->port_mode
is MUSB_OTG so the clean up code should only call mtk_otg_switch_exit()
for that mode.

Fixes: 0990366bab3c ("usb: musb: Add support for MediaTek musb controller")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y8/3TqpqiSr0RxFH@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/mediatek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/mediatek.c b/drivers/usb/musb/mediatek.c
index 6b92d037d8fc8..4f52b92c45974 100644
--- a/drivers/usb/musb/mediatek.c
+++ b/drivers/usb/musb/mediatek.c
@@ -346,7 +346,8 @@ static int mtk_musb_init(struct musb *musb)
 err_phy_power_on:
 	phy_exit(glue->phy);
 err_phy_init:
-	mtk_otg_switch_exit(glue);
+	if (musb->port_mode == MUSB_OTG)
+		mtk_otg_switch_exit(glue);
 	return ret;
 }
 
-- 
2.39.2



