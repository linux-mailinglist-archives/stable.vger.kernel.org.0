Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46DA4F3C0C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382295AbiDEMEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358183AbiDEK2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467C39E9D6;
        Tue,  5 Apr 2022 03:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC38FB81C8A;
        Tue,  5 Apr 2022 10:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40774C385A1;
        Tue,  5 Apr 2022 10:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153787;
        bh=qQkG5DprhOohE/vv7FqAicjZ5OSnoUow72LwglFkNNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLYXVX1IAkGu7jGj93lP0Hwmmtk/00flU1CTCSo66D0HzFYcvCQxYleGrvsnqsbgB
         otJVshTEmNBOOiQSoPt2JG7ct+Brnhhz1RoDqnCJ+W1QubN1vIEewETQ9SDMAP3Yc3
         DiH96Z4ZnzXP91D2WlDYQsv3BbXdUJo9jhhSHucg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/599] platform/x86: huawei-wmi: check the return value of device_create_file()
Date:   Tue,  5 Apr 2022 09:30:41 +0200
Message-Id: <20220405070309.153077583@linuxfoundation.org>
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

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit c91a5b1c221a58d008485cf7d02ccce73108b119 ]

The function device_create_file() in huawei_wmi_battery_add() can fail,
so its return value should be checked.

Fixes: 355a070b09ab ("platform/x86: huawei-wmi: Add battery charging thresholds")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20220303022421.313-1-baijiaju1990@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/huawei-wmi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/huawei-wmi.c b/drivers/platform/x86/huawei-wmi.c
index a2d846c4a7ee..eac3e6b4ea11 100644
--- a/drivers/platform/x86/huawei-wmi.c
+++ b/drivers/platform/x86/huawei-wmi.c
@@ -470,10 +470,17 @@ static DEVICE_ATTR_RW(charge_control_thresholds);
 
 static int huawei_wmi_battery_add(struct power_supply *battery)
 {
-	device_create_file(&battery->dev, &dev_attr_charge_control_start_threshold);
-	device_create_file(&battery->dev, &dev_attr_charge_control_end_threshold);
+	int err = 0;
 
-	return 0;
+	err = device_create_file(&battery->dev, &dev_attr_charge_control_start_threshold);
+	if (err)
+		return err;
+
+	err = device_create_file(&battery->dev, &dev_attr_charge_control_end_threshold);
+	if (err)
+		device_remove_file(&battery->dev, &dev_attr_charge_control_start_threshold);
+
+	return err;
 }
 
 static int huawei_wmi_battery_remove(struct power_supply *battery)
-- 
2.34.1



