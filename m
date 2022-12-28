Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4405A65821B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiL1QdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiL1Qcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39B43AD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B166CB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7C4C433D2;
        Wed, 28 Dec 2022 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244996;
        bh=LYR2MszpcfxALpm6QqqLQhYFaWt7DyQX8GcTxgD7xv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1E3mwQfgszQ8f0RJdxrYtpy3Vmt2Bin52YpBQTSOzH4Q2MIFXwZTwl/SGLTXrvExs
         Wq3oDGEKzJLW52ANTeWvrlW1mndRG+YZ7Z5OPmrMrVGKMy6g3lfI4EW9W+OslhgJkC
         O+YWATQf96O9wLvZ579Up8ZBLxfX9evS8KXEkHzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0775/1146] power: supply: cw2015: Fix potential null-ptr-deref in cw_bat_probe()
Date:   Wed, 28 Dec 2022 15:38:34 +0100
Message-Id: <20221228144351.198770354@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 97f2b4ddb0aa700d673691a7d5e44d226d22bab7 ]

cw_bat_probe() calls create_singlethread_workqueue() and not checked the
ret value, which may return NULL. And a null-ptr-deref may happen:

cw_bat_probe()
    create_singlethread_workqueue() # failed, cw_bat->wq is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL.

Fixes: b4c7715c10c1 ("power: supply: add CellWise cw2015 fuel gauge driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 6d52641151d9..473522b4326a 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -699,6 +699,9 @@ static int cw_bat_probe(struct i2c_client *client)
 	}
 
 	cw_bat->battery_workqueue = create_singlethread_workqueue("rk_battery");
+	if (!cw_bat->battery_workqueue)
+		return -ENOMEM;
+
 	devm_delayed_work_autocancel(&client->dev,
 							  &cw_bat->battery_delay_work, cw_bat_work);
 	queue_delayed_work(cw_bat->battery_workqueue,
-- 
2.35.1



