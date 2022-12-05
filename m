Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE566432CF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiLET3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiLET3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:29:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E1E26113
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:26:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E129161314
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0222FC433C1;
        Mon,  5 Dec 2022 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268361;
        bh=/5Go+EPS69YGrGMCX9TKxfABa7fXHnnuqSsDZ4z0Dko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlucN/m8KePGbPk368umWkUw0YQYmty2iRRKHQCpAnZD8qzYWBgMG/qssBXGYFDLe
         fJFQCiOMft7GTyZG3+kENk45LOO4H65I0mTpWrTGNe+hlOE3aBEsP6ETyDpIEryLT/
         a78WvJKrIQACVmOHr5AvdP+wW2seHTc+WpytugM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 074/124] hwmon: (asus-ec-sensors) Add checks for devm_kcalloc
Date:   Mon,  5 Dec 2022 20:09:40 +0100
Message-Id: <20221205190810.527303663@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 9bdc112be727cf1ba65be79541147f960c3349d8 ]

As the devm_kcalloc may return NULL, the return value needs to be checked
to avoid NULL poineter dereference.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221125014329.121560-1-yuancan@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 81e688975c6a..a901e4e33d81 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -938,6 +938,8 @@ static int asus_ec_probe(struct platform_device *pdev)
 	ec_data->nr_sensors = hweight_long(ec_data->board_info->sensors);
 	ec_data->sensors = devm_kcalloc(dev, ec_data->nr_sensors,
 					sizeof(struct ec_sensor), GFP_KERNEL);
+	if (!ec_data->sensors)
+		return -ENOMEM;
 
 	status = setup_lock_data(dev);
 	if (status) {
-- 
2.35.1



