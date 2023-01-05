Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333B465EBF6
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbjAENEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbjAENEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:04:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301425B153
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:04:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1956619FF
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EC1C433D2;
        Thu,  5 Jan 2023 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923861;
        bh=e1TZUmqdXA2WETOA+Sy2HNIXm5NpPmI353NpDaIPfAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6s35Kh4RKp0Qz4LMx5oYbA/6X0TnMbu/z9R/b0iKrdvIdXif74ITbnyQWDAU8+pP
         x9K04zlEAjRzyIR6S1RIagBFPj+T5jJkWzq7EI6f/nNtXlUdIlj6uST528PtZD6gNs
         fGZ7YPDFEAF2hQSXoy7XCRRZ+Jr/3JjMerFvmxKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 155/251] power: supply: fix residue sysfs file in error handle route of __power_supply_register()
Date:   Thu,  5 Jan 2023 13:54:52 +0100
Message-Id: <20230105125341.920817377@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 5b79480ce1978864ac3f06f2134dfa3b6691fe74 ]

If device_add() succeeds, we should call device_del() when want to
get rid of it, so move it into proper jump symbol.

Otherwise, when __power_supply_register() returns fail and goto
wakeup_init_failed to exit, there is still residue device file in sysfs.
When attempt to probe device again, sysfs would complain as below:

sysfs: cannot create duplicate filename '/devices/platform/i2c/i2c-0/0-001c/power_supply/adp5061'
Call Trace:
 dump_stack_lvl+0x68/0x85
 sysfs_warn_dup.cold+0x1c/0x29
 sysfs_create_dir_ns+0x1b1/0x1d0
 kobject_add_internal+0x143/0x390
 kobject_add+0x108/0x170

Fixes: 80c6463e2fa3 ("power_supply: Fix Oops from NULL pointer dereference from wakeup_source_activate")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index cb0b3d3d132f..af156b7f346f 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -807,8 +807,8 @@ __power_supply_register(struct device *parent,
 register_cooler_failed:
 	psy_unregister_thermal(psy);
 register_thermal_failed:
-	device_del(dev);
 wakeup_init_failed:
+	device_del(dev);
 device_add_failed:
 check_supplies_failed:
 dev_set_name_failed:
-- 
2.35.1



