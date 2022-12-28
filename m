Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195B5657EE0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiL1P6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiL1P6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F334F183B3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 676B2CE1369
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5844BC433EF;
        Wed, 28 Dec 2022 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243113;
        bh=EYBmkEcnndsWfvt7ODrn0GRA9KEwevxS2YF+FZyi1Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0/3ocKXhkKxtKH+sFo97fL4RqFPFe3XACeLdZUxhw1M+KmfNfaeAfCnNNuZru8Km
         dWKM9ZtXWYudTiAYW0ZhezdX19LY4SSwflD3vhIK87mFZRAyVWzevo0D7zkfmi7/sg
         P5+Mv5W7L3tZn7/rOhDGNlQ4pIcuqkbVkSgzr30U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 685/731] hwmon: (jc42) Fix missing unlock on error in jc42_write()
Date:   Wed, 28 Dec 2022 15:43:12 +0100
Message-Id: <20221228144316.325152690@linuxfoundation.org>
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
index 5240bfdfcf2e..52f341d46029 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -340,7 +340,7 @@ static int jc42_write(struct device *dev, enum hwmon_sensor_types type,
 		ret = regmap_read(data->regmap, JC42_REG_TEMP_CRITICAL,
 				  &regval);
 		if (ret)
-			return ret;
+			break;
 
 		/*
 		 * JC42.4 compliant chips only support four hysteresis values.
-- 
2.35.1



