Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C745E657FD5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiL1QKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiL1QKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:10:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F321A380
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8B3B6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CB4C433EF;
        Wed, 28 Dec 2022 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243718;
        bh=BtLffO+3Gb4T0px8/3Ad1Wxi+x0cyol3HvDsLe14VPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtVaMIPGrr5ESEKkTx9sMmNGul3pb5D0bgHKMA0W6KLn7OtF2PyteewavDNb4K2nd
         YiEHiyUpNMRZt+QHXV73W5Fa0tezgbc42iqXphqtXZImCr4v7wJgVUHTYvGRHi5JlW
         XaCb1IOK1ZV6fKxY7Vs5SvR0FGrBTnQ/9Wx9jlNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Marek Vasut <marex@denx.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 731/731] extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is registered
Date:   Wed, 28 Dec 2022 15:43:58 +0100
Message-Id: <20221228144317.630974485@linuxfoundation.org>
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
 


