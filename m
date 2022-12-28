Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E826583C2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiL1Qvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiL1QvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:51:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B71F10CB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA3606157C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F82C433D2;
        Wed, 28 Dec 2022 16:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245951;
        bh=IbJt7hoDzTGeI/HrT8fi9aO+cZYR8AAZaGsSXvLuF9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFdsGm8uR51eHdd370ind7JYdyqEBMxDLU3GlS+0xB0aCBdDuUwX6j/uMKb9wyHSx
         4SO9Xb7sYvgFJ40tFh3lv/SBGre7kP/+wsuk1qL4FqJ8vQEdl5fsEhFIn+5A+3pLjw
         SqZUYfd2tzGMtOSQC1pqZpDBdke5sWDtaav8w4hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0952/1146] thermal/core: Ensure that thermal device is registered in thermal_zone_get_temp
Date:   Wed, 28 Dec 2022 15:41:31 +0100
Message-Id: <20221228144356.177248052@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 1c6b30060777352e7881383bab726046d8c3c610 ]

Calls to thermal_zone_get_temp() are not protected against thermal zone
device removal. As result, it is possible that the thermal zone operations
callbacks are no longer valid when thermal_zone_get_temp() is called.
This may result in crashes such as

BUG: unable to handle page fault for address: ffffffffc04ef420
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
PGD 5d60e067 P4D 5d60e067 PUD 5d610067 PMD 110197067 PTE 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 1 PID: 3209 Comm: cat Tainted: G        W         5.10.136-19389-g615abc6eb807 #1 02df41ac0b12f3a64f4b34245188d8875bb3bce1
Hardware name: Google Coral/Coral, BIOS Google_Coral.10068.92.0 11/27/2018
RIP: 0010:thermal_zone_get_temp+0x26/0x73
Code: 89 c3 eb d3 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 53 48 85 ff 74 50 48 89 fb 48 81 ff 00 f0 ff ff 77 44 48 8b 83 98 03 00 00 <48> 83 78 10 00 74 36 49 89 f6 4c 8d bb d8 03 00 00 4c 89 ff e8 9f
RSP: 0018:ffffb3758138fd38 EFLAGS: 00010287
RAX: ffffffffc04ef410 RBX: ffff98f14d7fb000 RCX: 0000000000000000
RDX: ffff98f17cf90000 RSI: ffffb3758138fd64 RDI: ffff98f14d7fb000
RBP: ffffb3758138fd50 R08: 0000000000001000 R09: ffff98f17cf90000
R10: 0000000000000000 R11: ffffffff8dacad28 R12: 0000000000001000
R13: ffff98f1793a7d80 R14: ffff98f143231708 R15: ffff98f14d7fb018
FS:  00007ec166097800(0000) GS:ffff98f1bbd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffc04ef420 CR3: 000000010ee9a000 CR4: 00000000003506e0
Call Trace:
 temp_show+0x31/0x68
 dev_attr_show+0x1d/0x4f
 sysfs_kf_seq_show+0x92/0x107
 seq_read_iter+0xf5/0x3f2
 vfs_read+0x205/0x379
 __x64_sys_read+0x7c/0xe2
 do_syscall_64+0x43/0x55
 entry_SYSCALL_64_after_hwframe+0x61/0xc6

if a thermal device is removed while accesses to its device attributes
are ongoing.

The problem is exposed by code in iwl_op_mode_mvm_start(), which registers
a thermal zone device only to unregister it shortly afterwards if an
unrelated failure is encountered while accessing the hardware.

Check if the thermal zone device is registered after acquiring the
thermal zone device mutex to ensure this does not happen.

The code was tested by triggering the failure in iwl_op_mode_mvm_start()
on purpose. Without this patch, the kernel crashes reliably. The crash
is no longer observed after applying this and the preceding patches.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_helpers.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_helpers.c b/drivers/thermal/thermal_helpers.c
index c65cdce8f856..fca0b23570f9 100644
--- a/drivers/thermal/thermal_helpers.c
+++ b/drivers/thermal/thermal_helpers.c
@@ -115,7 +115,12 @@ int thermal_zone_get_temp(struct thermal_zone_device *tz, int *temp)
 	int ret;
 
 	mutex_lock(&tz->lock);
-	ret = __thermal_zone_get_temp(tz, temp);
+
+	if (device_is_registered(&tz->device))
+		ret = __thermal_zone_get_temp(tz, temp);
+	else
+		ret = -ENODEV;
+
 	mutex_unlock(&tz->lock);
 
 	return ret;
-- 
2.35.1



