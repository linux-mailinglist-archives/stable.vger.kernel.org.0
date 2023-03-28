Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2B96CC3BF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbjC1O5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbjC1O5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:57:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1084D33A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C9B261840
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C18EC433D2;
        Tue, 28 Mar 2023 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015420;
        bh=dEGTYd5h/mthWoggGZqA8yP97QRfq6qADAyuWCJ4NJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkAHf2M0CRGqmIXk3StO5MlPeaHbtaZrEop60W4ipL3OF02Wzlwb1jqMpFmrLrq2X
         lGoh0PeMroqAGw8u1kXp9fIsj2FACKamab80x7SJIE9LpvuoVQGa5t7pvhJlFMJVdP
         JYvev+tV8CLtdbwIhHS9oSLPqLQVxU1BZqqtIZfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/224] power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition
Date:   Tue, 28 Mar 2023 16:40:11 +0200
Message-Id: <20230328142617.901326549@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 47c29d69212911f50bdcdd0564b5999a559010d4 ]

In bq24190_probe, &bdi->input_current_limit_work is bound
with bq24190_input_current_limit_work. When external power
changed, it will call bq24190_charger_external_power_changed
 to start the work.

If we remove the module which will call bq24190_remove to make
cleanup, there may be a unfinished work. The possible
sequence is as follows:

CPU0                  CPUc1

                    |bq24190_input_current_limit_work
bq24190_remove      |
power_supply_unregister  |
device_unregister   |
power_supply_dev_release|
kfree(psy)          |
                    |
                    | power_supply_get_property_from_supplier
                    |   //use

Fix it by finishing the work before cleanup in the bq24190_remove

Fixes: 97774672573a ("power_supply: Initialize changed_work before calling device_add")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 2274679c5ddd2..d7400b56820d6 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -1906,6 +1906,7 @@ static void bq24190_remove(struct i2c_client *client)
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
+	cancel_delayed_work_sync(&bdi->input_current_limit_work);
 	error = pm_runtime_resume_and_get(bdi->dev);
 	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-- 
2.39.2



