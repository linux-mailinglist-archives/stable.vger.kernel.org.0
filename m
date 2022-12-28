Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38BA657E93
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbiL1PzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbiL1PzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:55:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DF718B16
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EBEE61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44848C433D2;
        Wed, 28 Dec 2022 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242906;
        bh=vuoz5BJfDr89hu6KaL4k1HR5x5eg+/9gWPsl+Z4jtDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1M8ywnE9ZREq8dw8N8mOJWWOiIPQiNdDtAFOa1/JHSblI8QMEJYVVgFE7C1bV/n2z
         bFpd9tvNRYf8V5ktRGWbXpw8luWu0xf4AlrYn7h3tu7xZYnxbH1pVHeE8bq4hY5SZK
         G5GZe5DzSnfBmSKqnMz6REQtiNplZt05eMyKOi+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Guoniu.zhou" <guoniu.zhou@nxp.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0468/1073] media: ov5640: set correct default link frequency
Date:   Wed, 28 Dec 2022 15:34:16 +0100
Message-Id: <20221228144340.748933111@linuxfoundation.org>
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

From: Guoniu.zhou <guoniu.zhou@nxp.com>

[ Upstream commit d7b41196927ba2a2b5badad1a85f9087eb90b076 ]

current_link_freq field in ov5640_dev structure is link frequency,
not link frequency array index, so correct it.

Fixes: 3c28588f35d3 ("media: ov5640: Update pixel_rate and link_freq")
Signed-off-by: Guoniu.zhou <guoniu.zhou@nxp.com>
Acked-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 502f0b62e950..7e72e7c7b0dd 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3816,7 +3816,8 @@ static int ov5640_probe(struct i2c_client *client)
 	sensor->current_mode =
 		&ov5640_mode_data[OV5640_MODE_VGA_640_480];
 	sensor->last_mode = sensor->current_mode;
-	sensor->current_link_freq = OV5640_DEFAULT_LINK_FREQ;
+	sensor->current_link_freq =
+		ov5640_csi2_link_freqs[OV5640_DEFAULT_LINK_FREQ];
 
 	sensor->ae_target = 52;
 
-- 
2.35.1



