Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE454972F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380551AbiFMOHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381990AbiFMOFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:05:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C2193468;
        Mon, 13 Jun 2022 04:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F380561342;
        Mon, 13 Jun 2022 11:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5ADC34114;
        Mon, 13 Jun 2022 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120418;
        bh=mEwbqgWojyxtkqgxEaRPGMELVaiZS+FLu/4v3N6gpOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TClz/8E0JvHVOVsFKf2WeFjHCXsxiNfR22o0zZ7QDKlFhPaRYzbY21borrAAjEfVO
         IV6/OEMiw4tWERSc/tfhUQQIsStlnuT5WdM1xefPd8Yx6QuFdhI+vhmMSGqs8UIFhR
         ckpF25rXGZ5rX/DZsEjmGZB7yqBcAl2/1/ExKPNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 026/298] usb: typec: mux: Check dev_set_name() return value
Date:   Mon, 13 Jun 2022 12:08:40 +0200
Message-Id: <20220613094925.724029025@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit b9fa0292490db39d6542f514117333d366ec0011 ]

It's possible that dev_set_name() returns -ENOMEM, catch and handle this.

Fixes: 3370db35193b ("usb: typec: Registering real device entries for the muxes")
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220422222351.1297276-4-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index c8340de0ed49..d2aaf294b649 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -131,8 +131,11 @@ typec_switch_register(struct device *parent,
 	sw->dev.class = &typec_mux_class;
 	sw->dev.type = &typec_switch_dev_type;
 	sw->dev.driver_data = desc->drvdata;
-	dev_set_name(&sw->dev, "%s-switch",
-		     desc->name ? desc->name : dev_name(parent));
+	ret = dev_set_name(&sw->dev, "%s-switch", desc->name ? desc->name : dev_name(parent));
+	if (ret) {
+		put_device(&sw->dev);
+		return ERR_PTR(ret);
+	}
 
 	ret = device_add(&sw->dev);
 	if (ret) {
@@ -338,8 +341,11 @@ typec_mux_register(struct device *parent, const struct typec_mux_desc *desc)
 	mux->dev.class = &typec_mux_class;
 	mux->dev.type = &typec_mux_dev_type;
 	mux->dev.driver_data = desc->drvdata;
-	dev_set_name(&mux->dev, "%s-mux",
-		     desc->name ? desc->name : dev_name(parent));
+	ret = dev_set_name(&mux->dev, "%s-mux", desc->name ? desc->name : dev_name(parent));
+	if (ret) {
+		put_device(&mux->dev);
+		return ERR_PTR(ret);
+	}
 
 	ret = device_add(&mux->dev);
 	if (ret) {
-- 
2.35.1



