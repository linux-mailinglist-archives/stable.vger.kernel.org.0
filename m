Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6816577F8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiL1Oo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiL1OoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:44:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F3C11805
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:44:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB7B761545
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D712CC433D2;
        Wed, 28 Dec 2022 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238652;
        bh=RuPFItVFrA3lFN2h8va0QCL6GH4BnmYHIGbLTxukDyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaRkCf6tMM3JfFmudHG84Ci7rpFcUxRB7Ch+XG0yuL0fuJm2igPJxXqUtYajvPdUX
         xW6mJqdjhEjdP2UwK9o/NssXUUbGmCn77SgjNR5CrpNHyBFSttXdUFYqt7T8feI+8p
         z105W0sPJIOVyAjze6ybNG3mzkAsZPChrCSmyfX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/731] usb: musb: remove extra check in musb_gadget_vbus_draw
Date:   Wed, 28 Dec 2022 15:31:49 +0100
Message-Id: <20221228144256.609772709@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>

[ Upstream commit ecec4b20d29c3d6922dafe7d2555254a454272d2 ]

The checks for musb->xceiv and musb->xceiv->set_power duplicate those in
usb_phy_set_power(), so there is no need of them. Moreover, not calling
usb_phy_set_power() results in usb_phy_set_charger_current() not being
called, so current USB config max current is not propagated through USB
charger framework and charger drivers may try to draw more current than
allowed or possible.

Fix that by removing those extra checks and calling usb_phy_set_power()
directly.

Tested on Motorola Droid4 and Nokia N900

Fixes: a9081a008f84 ("usb: phy: Add USB charger support")
Cc: stable <stable@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Link: https://lore.kernel.org/r/1669400475-4762-1-git-send-email-ivo.g.dimitrov.75@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_gadget.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index dc67fff8e941..22c3df49ba8a 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1628,8 +1628,6 @@ static int musb_gadget_vbus_draw(struct usb_gadget *gadget, unsigned mA)
 {
 	struct musb	*musb = gadget_to_musb(gadget);
 
-	if (!musb->xceiv->set_power)
-		return -EOPNOTSUPP;
 	return usb_phy_set_power(musb->xceiv, mA);
 }
 
-- 
2.35.1



