Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34C0615811
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiKBCo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874E520F46
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 255C0617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624C6C433D6;
        Wed,  2 Nov 2022 02:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357093;
        bh=+ve+K4AgXyLZz7CAjwwNrOJG5NdE6ZTfapjdDQ4q8ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrY7bqrqpW+NqYNfUmMP/h8OIlZRt5zA6Q/MSFOP/48/q4iuOiWrJ3OvOZGyHXAEm
         G0cFmkarI9f5Tg5Y4TzyH6g6ptMo3Kc3at2nWiW5a7MgS8znegvBZh521trQarleXl
         O4hWDVcnW3xEpDGug+2YjhjCqSN6iAxvOIkfeJCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 111/240] media: ar0521: fix error return code in ar0521_power_on()
Date:   Wed,  2 Nov 2022 03:31:26 +0100
Message-Id: <20221102022113.899510510@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b5f8fa876931c1adfd2c5eca5b189fd2be893238 ]

Return error code if ar0521_write_regs() fails in ar0521_power_on().

Fixes: 852b50aeed15 ("media: On Semi AR0521 sensor driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ar0521.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ar0521.c b/drivers/media/i2c/ar0521.c
index c7bdfc69b9be..e850c92d847e 100644
--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -757,8 +757,9 @@ static int ar0521_power_on(struct device *dev)
 	usleep_range(4500, 5000); /* min 45000 clocks */
 
 	for (cnt = 0; cnt < ARRAY_SIZE(initial_regs); cnt++)
-		if (ar0521_write_regs(sensor, initial_regs[cnt].data,
-				      initial_regs[cnt].count))
+		ret = ar0521_write_regs(sensor, initial_regs[cnt].data,
+					initial_regs[cnt].count);
+		if (ret)
 			goto off;
 
 	ret = ar0521_write_reg(sensor, AR0521_REG_SERIAL_FORMAT,
-- 
2.35.1



