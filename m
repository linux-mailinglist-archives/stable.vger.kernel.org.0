Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9561C6579C6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiL1PEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiL1PEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:04:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2268413D49
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE46EB816D6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C1BC433F0;
        Wed, 28 Dec 2022 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239872;
        bh=iyu9Upqa+B+/0iUubhYlutIvi5/UDytjojjYFweiQSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbIttuM2m2VBXgxb1fHxXZk46/MwQoBebxxraTnF1GJQyFNeEuZ5G2I4pCHZ3Cjb9
         GJbllIvWA8DEi6rVYNbVJZH2wQvF4Wjd7LvrBIFS4OmBcX4/dhWHjEVdmQ7PX3mvS3
         zL1BT+tfIrTYsdhTZfe+yqmtGcwHIrPaD3+PiRFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/731] regulator: core: fix resource leak in regulator_register()
Date:   Wed, 28 Dec 2022 15:36:27 +0100
Message-Id: <20221228144304.689577366@linuxfoundation.org>
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

[ Upstream commit ba62319a42c50e6254e98b3f316464fac8e77968 ]

I got some resource leak reports while doing fault injection test:

  OF: ERROR: memory leak, expected refcount 1 instead of 100,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/pmic@64/regulators/buck1

unreferenced object 0xffff88810deea000 (size 512):
  comm "490-i2c-rt5190a", pid 253, jiffies 4294859840 (age 5061.046s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff a0 1e 00 a1 ff ff ff ff  ................
  backtrace:
    [<00000000d78541e2>] kmalloc_trace+0x21/0x110
    [<00000000b343d153>] device_private_init+0x32/0xd0
    [<00000000be1f0c70>] device_add+0xb2d/0x1030
    [<00000000e3e6344d>] regulator_register+0xaf2/0x12a0
    [<00000000e2f5e754>] devm_regulator_register+0x57/0xb0
    [<000000008b898197>] rt5190a_probe+0x52a/0x861 [rt5190a_regulator]

unreferenced object 0xffff88810b617b80 (size 32):
  comm "490-i2c-rt5190a", pid 253, jiffies 4294859904 (age 5060.983s)
  hex dump (first 32 bytes):
    72 65 67 75 6c 61 74 6f 72 2e 32 38 36 38 2d 53  regulator.2868-S
    55 50 50 4c 59 00 ff ff 29 00 00 00 2b 00 00 00  UPPLY...)...+...
  backtrace:
    [<000000009da9280d>] __kmalloc_node_track_caller+0x44/0x1b0
    [<0000000025c6a4e5>] kstrdup+0x3a/0x70
    [<00000000790efb69>] create_regulator+0xc0/0x4e0
    [<0000000005ed203a>] regulator_resolve_supply+0x2d4/0x440
    [<0000000045796214>] regulator_register+0x10b3/0x12a0
    [<00000000e2f5e754>] devm_regulator_register+0x57/0xb0
    [<000000008b898197>] rt5190a_probe+0x52a/0x861 [rt5190a_regulator]

After calling regulator_resolve_supply(), the 'rdev->supply' is set
by set_supply(), after this set, in the error path, the resources
need be released, so call regulator_put() to avoid the leaks.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Fixes: 8a866d527ac0 ("regulator: core: Resolve supply name earlier to prevent double-init")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221202025111.496402-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ab93debb817c..1a5aeb4868aa 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5548,6 +5548,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	regulator_remove_coupling(rdev);
 	mutex_unlock(&regulator_list_mutex);
 wash:
+	regulator_put(rdev->supply);
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	mutex_lock(&regulator_list_mutex);
 	regulator_ena_gpio_free(rdev);
-- 
2.35.1



