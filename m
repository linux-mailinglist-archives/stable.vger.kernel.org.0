Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2174F4305
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382352AbiDEMO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242757AbiDEKfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D0ADF484;
        Tue,  5 Apr 2022 03:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E22661676;
        Tue,  5 Apr 2022 10:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464A6C385A0;
        Tue,  5 Apr 2022 10:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153957;
        bh=mNrzE2y4jaCJIXuG3CMdKKY1QnNmRPTne+P4BnMs2vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OySDktq2zJPzVgp9jSLLzaR/mHXNUmJ7Z5HjDSlrH4xkwecR+CZGCfwqCB5XCjT4H
         etQY9lFuVbKnRdwDpvtbCs8HV7YRImqoEFYjvgS0B9N1YJ3O7QnMyGkSHOsswbSlLt
         x1M8oS2SK1zKPhphtLZM8tWH+2qP20MASb4UXgj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 370/599] i2c: mux: demux-pinctrl: do not deactivate a master that is not active
Date:   Tue,  5 Apr 2022 09:31:04 +0200
Message-Id: <20220405070309.840620402@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 5365199a31f4..f7a7405d4350 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -261,7 +261,7 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
 	err = device_create_file(&pdev->dev, &dev_attr_available_masters);
 	if (err)
-		goto err_rollback;
+		goto err_rollback_activation;
 
 	err = device_create_file(&pdev->dev, &dev_attr_current_master);
 	if (err)
@@ -271,8 +271,9 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
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



