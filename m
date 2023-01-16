Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1EE66C80D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbjAPQgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjAPQft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369FA24137
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:23:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C59C86104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D668FC433D2;
        Mon, 16 Jan 2023 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886235;
        bh=H4ZpO9AyrrwwHRojmMI8gUAIXb+d4UhAa1XbE6A4XFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AlWu5tWCPb8d1+ckTZNnO8HtgIS6dP+flwvTHoBTyavJZHcElisE7Ok4rx2T8s+T
         0nvwTs/xHG69Tlk2qdby2vtw0UQhsSzi2Uk3yq4wqlSu4mwBiTvh+WFruq/W9Jq4+A
         1KGFiurq8fIUK1Y68MAaO8d8l08nwKe5bu/ygUDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 323/658] power: supply: fix residue sysfs file in error handle route of __power_supply_register()
Date:   Mon, 16 Jan 2023 16:46:51 +0100
Message-Id: <20230116154924.340775754@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index a2f56a68c50d..3afc0b833eb8 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1104,8 +1104,8 @@ __power_supply_register(struct device *parent,
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



