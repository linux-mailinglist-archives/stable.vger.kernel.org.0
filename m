Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70476CC3C3
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbjC1O5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbjC1O5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:57:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E922E061
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11166B81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68922C433D2;
        Tue, 28 Mar 2023 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015431;
        bh=AYQK/nW9l4cl/DtggUNloxtu/0Ez46kxbDH+CvduZ00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tU26IrpwAeTBwVCsXJSTj/nJMcb0zw4uJNNH8+sb668sfx72iEdROcxEKHFyb91Ot
         vkCqgZnJ9WU+OvSguE1lgEVv7rf8XExomni2Rmcjh7XuhKyMKRHYETRyqQdMS9xirE
         lJsCD7RgJxSA4PoUmq2xSSfOA9hj/ydKEDtbQVCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/224] power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition
Date:   Tue, 28 Mar 2023 16:40:12 +0200
Message-Id: <20230328142617.951846246@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 06615d11cc78162dfd5116efb71f29eb29502d37 ]

In da9150_charger_probe, &charger->otg_work is bound with
da9150_charger_otg_work. da9150_charger_otg_ncb may be
called to start the work.

If we remove the module which will call da9150_charger_remove
to make cleanup, there may be a unfinished work. The possible
sequence is as follows:

Fix it by canceling the work before cleanup in the da9150_charger_remove

CPU0                  CPUc1

                    |da9150_charger_otg_work
da9150_charger_remove      |
power_supply_unregister  |
device_unregister   |
power_supply_dev_release|
kfree(psy)          |
                    |
                    | 	power_supply_changed(charger->usb);
                    |   //use

Fixes: c1a281e34dae ("power: Add support for DA9150 Charger")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/da9150-charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/da9150-charger.c b/drivers/power/supply/da9150-charger.c
index f9314cc0cd75f..6b987da586556 100644
--- a/drivers/power/supply/da9150-charger.c
+++ b/drivers/power/supply/da9150-charger.c
@@ -662,6 +662,7 @@ static int da9150_charger_remove(struct platform_device *pdev)
 
 	if (!IS_ERR_OR_NULL(charger->usb_phy))
 		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+	cancel_work_sync(&charger->otg_work);
 
 	power_supply_unregister(charger->battery);
 	power_supply_unregister(charger->usb);
-- 
2.39.2



