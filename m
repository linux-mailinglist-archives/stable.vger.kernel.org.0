Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD78541CB7
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355157AbiFGWEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382547AbiFGWDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:03:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D66D252240;
        Tue,  7 Jun 2022 12:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED37D61846;
        Tue,  7 Jun 2022 19:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083A8C385A5;
        Tue,  7 Jun 2022 19:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629315;
        bh=ozUGUxXjZ0SLqJrR+0taUaj3gF28+ijUtxbb/5RCXvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/uoaSrDoocPVciIBlMya+1GYtVkmTy0cdO21Yruf/wpf8ICqULc2y2s2HoA2MR/L
         VTEmIMrvC/jjDnU6bBBJxTEIY/azEDDLLyTfkbdgJ/C5YMT+9SqnilVqu+gPQYWXcP
         ndhPiHeL2YCYnL7RgQg/Gq4RFUxHIx5LMIZI6DqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 648/879] gpio: sim: Use correct order for the parameters of devm_kcalloc()
Date:   Tue,  7 Jun 2022 19:02:46 +0200
Message-Id: <20220607165021.656260726@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c680c6a814a2269427fad9ac417ab16756bceae9 ]

We should have 'n', then 'size', not the opposite.
This is harmless because the 2 values are just multiplied, but having
the correct order silence a (unpublished yet) smatch warning.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index 41c31b10ae84..98109839102f 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -314,8 +314,8 @@ static int gpio_sim_setup_sysfs(struct gpio_sim_chip *chip)
 
 	for (i = 0; i < num_lines; i++) {
 		attr_group = devm_kzalloc(dev, sizeof(*attr_group), GFP_KERNEL);
-		attrs = devm_kcalloc(dev, sizeof(*attrs),
-				     GPIO_SIM_NUM_ATTRS, GFP_KERNEL);
+		attrs = devm_kcalloc(dev, GPIO_SIM_NUM_ATTRS, sizeof(*attrs),
+				     GFP_KERNEL);
 		val_attr = devm_kzalloc(dev, sizeof(*val_attr), GFP_KERNEL);
 		pull_attr = devm_kzalloc(dev, sizeof(*pull_attr), GFP_KERNEL);
 		if (!attr_group || !attrs || !val_attr || !pull_attr)
-- 
2.35.1



