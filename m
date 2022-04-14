Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB7D5014F1
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240851AbiDNNeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245283AbiDNN2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79231AACAA;
        Thu, 14 Apr 2022 06:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C88861158;
        Thu, 14 Apr 2022 13:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176F2C385A1;
        Thu, 14 Apr 2022 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942533;
        bh=UxmlfFxf3dLuXXSgmYyMu9vaX5TDGg8qYRlf17KsObs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h66ay4R69lhfxMnqXZbueGconfAepL50ucXYaNxOmzC0aFD6aAyrWFXN0o/f6bvDU
         JJGKkkdcm6GkJPYSY+QeTnoKl34cj3fo8BGJhNx8wqbtfQHHOE94GKlhTsJiH4KBXX
         EUnrIJ/mixEaN1rZyc4kEGKPonXYdOSH++nwOifc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/338] i2c: mux: demux-pinctrl: do not deactivate a master that is not active
Date:   Thu, 14 Apr 2022 15:10:56 +0200
Message-Id: <20220414110843.257606412@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit 1a22aabf20adf89cb216f566913196128766f25b ]

Attempting to rollback the activation of the current master when
the current master has not been activated is bad. priv->cur_chan
and priv->cur_adap are both still zeroed out and the rollback
may result in attempts to revert an of changeset that has not been
applied and do result in calls to both del and put the zeroed out
i2c_adapter. Maybe it crashes, or whatever, but it's bad in any
case.

Fixes: e9d1a0a41d44 ("i2c: mux: demux-pinctrl: Fix an error handling path in 'i2c_demux_pinctrl_probe()'")
Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index 9ba9ce5696e1..1b99d0b928a0 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -262,7 +262,7 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
 	err = device_create_file(&pdev->dev, &dev_attr_available_masters);
 	if (err)
-		goto err_rollback;
+		goto err_rollback_activation;
 
 	err = device_create_file(&pdev->dev, &dev_attr_current_master);
 	if (err)
@@ -272,8 +272,9 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
 err_rollback_available:
 	device_remove_file(&pdev->dev, &dev_attr_available_masters);
-err_rollback:
+err_rollback_activation:
 	i2c_demux_deactivate_master(priv);
+err_rollback:
 	for (j = 0; j < i; j++) {
 		of_node_put(priv->chan[j].parent_np);
 		of_changeset_destroy(&priv->chan[j].chgset);
-- 
2.34.1



