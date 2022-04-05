Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75034F2752
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiDEIGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiDEH6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7062CE13;
        Tue,  5 Apr 2022 00:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73A0A615C3;
        Tue,  5 Apr 2022 07:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AEBC34110;
        Tue,  5 Apr 2022 07:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145181;
        bh=8bnR6WJOLbID1I2AS7TV/Ck1iZ8G7QSKCKOQ8lAzl/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9Pb8ud7QlYN3WInT3Cc16TdlZIl0cTowEDSyS9PIY/uQM5VQhWo/fzGpOMPfKLCO
         5bxvnYTKk4JLpDGdTOHo1V8E0AcZ1j8PSQQWQRTwMzldq1aNyItdXe7Fhjkt5puxrG
         lB0Po27q3WYExASnTnIOHBHFHD0S8tn4LRQhV30Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0315/1126] media: ov2740: identify module after subdev initialisation
Date:   Tue,  5 Apr 2022 09:17:42 +0200
Message-Id: <20220405070416.862121724@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 54ade663d4bb606e23dbc4e0d49e2e9837dbb33f ]

The module identifying will try to get the sub device data which
will be ready after sub device initialisation, so if try to use the
subdev data to deference the client will cause NULL pointer
dereference, this patch move the module identification after
v4l2_i2c_subdev_init() to fix this issue, it also fixes duplicate
module idendification.

Fixes: ada2c4f54d0a ("media: ov2740: support device probe in non-zero ACPI D state")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2740.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov2740.c b/drivers/media/i2c/ov2740.c
index bab720c7c1de..d5f0eabf20c6 100644
--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -1162,6 +1162,7 @@ static int ov2740_probe(struct i2c_client *client)
 	if (!ov2740)
 		return -ENOMEM;
 
+	v4l2_i2c_subdev_init(&ov2740->sd, client, &ov2740_subdev_ops);
 	full_power = acpi_dev_state_d0(&client->dev);
 	if (full_power) {
 		ret = ov2740_identify_module(ov2740);
@@ -1171,13 +1172,6 @@ static int ov2740_probe(struct i2c_client *client)
 		}
 	}
 
-	v4l2_i2c_subdev_init(&ov2740->sd, client, &ov2740_subdev_ops);
-	ret = ov2740_identify_module(ov2740);
-	if (ret) {
-		dev_err(&client->dev, "failed to find sensor: %d", ret);
-		return ret;
-	}
-
 	mutex_init(&ov2740->mutex);
 	ov2740->cur_mode = &supported_modes[0];
 	ret = ov2740_init_controls(ov2740);
-- 
2.34.1



