Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D23594797
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355496AbiHOX4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355385AbiHOXwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEAC92F6E;
        Mon, 15 Aug 2022 13:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15FBBB8115B;
        Mon, 15 Aug 2022 20:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47133C433D6;
        Mon, 15 Aug 2022 20:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594605;
        bh=MEBQGLR4Wi8YUObvifBBBpQoQcSMmdCnvx59pobyrQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHKxf8d0kxwoQ9MwisoKksDJPeHs+QQmC/gi05Ak+XqgrYEH4bg1dR3WEoWmqM5TX
         Zgi7Q7tfP/fMCxQeqB6uaLP1XSX5GpAql3+ecG+MACnwrns431rjGVP9CZa3zVIiAX
         bGHTODN3LjlNNATqHwdTCrMpQUQSjjgXGp503ZqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0501/1157] media: ov7251: add missing disable functions on error in ov7251_set_power_on()
Date:   Mon, 15 Aug 2022 19:57:37 +0200
Message-Id: <20220815180459.734281331@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7a9795b31049b7e233d050a82b00094155a695c7 ]

Add the missing gpiod_set_value_cansleep() and clk_disable_unprepare()
before return from ov7251_set_power_on() in the error handling case.

Fixes: 9e1d3012cc10 ("media: i2c: Remove .s_power() from ov7251")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov7251.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov7251.c b/drivers/media/i2c/ov7251.c
index 0e7be15bc20a..ad9689820ecc 100644
--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -934,6 +934,8 @@ static int ov7251_set_power_on(struct device *dev)
 					ARRAY_SIZE(ov7251_global_init_setting));
 	if (ret < 0) {
 		dev_err(ov7251->dev, "error during global init\n");
+		gpiod_set_value_cansleep(ov7251->enable_gpio, 0);
+		clk_disable_unprepare(ov7251->xclk);
 		ov7251_regulators_disable(ov7251);
 		return ret;
 	}
-- 
2.35.1



