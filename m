Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8B7658489
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbiL1Q56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiL1Q5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2666D1573F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9FAEB8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B157C433D2;
        Wed, 28 Dec 2022 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246419;
        bh=BtLffO+3Gb4T0px8/3Ad1Wxi+x0cyol3HvDsLe14VPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNQzwFCOgDTaGLzA16jm0bvZpefkbDiTthfTT2Dej2QH3sqyfcLR0uVrFYDmdtFvI
         0F9VyRFIbk5ExyX+VRHv1NbLdlg+bcawvTA/wTXTK4ZFUu/jlq9HY9MugKrXtMBjWA
         WGSVfaVLHR82uhaOZhCe21ariGdwaOmNyvTStSPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Marek Vasut <marex@denx.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.0 1069/1073] extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is registered
Date:   Wed, 28 Dec 2022 15:44:17 +0100
Message-Id: <20221228144357.276732576@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Yassine Oudjana <y.oudjana@protonmail.com>

commit 341fd15e2e18c24d5c738496cfc3d7a272241201 upstream.

Commit bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
added an optional Type-C interface to the driver but missed to check
if it is in use when calling the IRQ handler. This causes an oops on
devices currently using the old extcon interface. Check if a Type-C
port is registered before calling the Type-C IRQ handler.

Fixes: bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221107153317.657803-1-y.oudjana@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-usbc-tusb320.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -327,7 +327,13 @@ static irqreturn_t tusb320_state_update_
 		return IRQ_NONE;
 
 	tusb320_extcon_irq_handler(priv, reg);
-	tusb320_typec_irq_handler(priv, reg);
+
+	/*
+	 * Type-C support is optional. Only call the Type-C handler if a
+	 * port had been registered previously.
+	 */
+	if (priv->port)
+		tusb320_typec_irq_handler(priv, reg);
 
 	regmap_write(priv->regmap, TUSB320_REG9, reg);
 


