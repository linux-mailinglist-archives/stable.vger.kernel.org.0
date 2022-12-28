Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C616584CC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiL1RCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbiL1RCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:02:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD971EEF7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52ECCB8188B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08E1C433D2;
        Wed, 28 Dec 2022 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246591;
        bh=KlD3D7u19WG6ygNouAh4CCAwHkRueQdvkNn87zCeWiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqFlmTNX0JvUNdgSZY6apq5ViO8Z+h4zf3ioHPKJhnSDatDoRo8IZXgmKguTdAd/a
         JZpnJYpowMj066hINe1HotwegHfCvkOhkHx5CsbYZlbmxyxg39Z8zx6Dxfgbc5Oa67
         pkBzmDzPcoqbyrawHll+C1e7NLebFD0a3F1dhDGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1065/1146] hwmon: (jc42) Fix missing unlock on error in jc42_write()
Date:   Wed, 28 Dec 2022 15:43:24 +0100
Message-Id: <20221228144359.194339681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b744db17abf6a2efc2bfa80870cc88e9799a8ccc ]

Add the missing unlock before return from function jc42_write()
in the error handling case.

Fixes: 37dedaee8bc6 ("hwmon: (jc42) Convert register access and caching to regmap/regcache")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20221027062931.598247-1-yangyingliang@huawei.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/jc42.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 0554b41c32bc..6593d81cb901 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -350,7 +350,7 @@ static int jc42_write(struct device *dev, enum hwmon_sensor_types type,
 		ret = regmap_read(data->regmap, JC42_REG_TEMP_CRITICAL,
 				  &regval);
 		if (ret)
-			return ret;
+			break;
 
 		/*
 		 * JC42.4 compliant chips only support four hysteresis values.
-- 
2.35.1



