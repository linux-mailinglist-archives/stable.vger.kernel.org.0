Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9502D6AF045
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCGS3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjCGS3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A188B1A5F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB966B818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C49EC433EF;
        Tue,  7 Mar 2023 18:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213340;
        bh=ioQ4OXnLMYg0Q6kyleOzRK0onhEe8RavH2BtK4xtyOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGk/OY6mOhMo1frKY750y1lmXCQQahOxoPVh0h05tojQ7qLN33BZqgudsZc2K1bbf
         Ewzqyw9GchdHz2WsEHTVCJOVSoRYRhNBfoQrTsLukxddgA6Gq0Ko9wLXRaEwgG8YEa
         J886rEVyaPc8uogpFMq6VStKwzs5+zuMI8tgQsJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 446/885] firmware: dmi-sysfs: Fix null-ptr-deref in dmi_sysfs_register_handle
Date:   Tue,  7 Mar 2023 17:56:20 +0100
Message-Id: <20230307170021.838646888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 18e126e97c961f7a93823795c879d7c085fe5098 ]

KASAN reported a null-ptr-deref error:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 1373 Comm: modprobe
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
RIP: 0010:dmi_sysfs_entry_release
...
Call Trace:
 <TASK>
 kobject_put
 dmi_sysfs_register_handle (drivers/firmware/dmi-sysfs.c:540) dmi_sysfs
 dmi_decode_table (drivers/firmware/dmi_scan.c:133)
 dmi_walk (drivers/firmware/dmi_scan.c:1115)
 dmi_sysfs_init (drivers/firmware/dmi-sysfs.c:149) dmi_sysfs
 do_one_initcall (init/main.c:1296)
 ...
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x4000000 from 0xffffffff81000000
---[ end Kernel panic - not syncing: Fatal exception ]---

It is because previous patch added kobject_put() to release the memory
which will call  dmi_sysfs_entry_release() and list_del().

However, list_add_tail(entry->list) is called after the error block,
so the list_head is uninitialized and cannot be deleted.

Move error handling to after list_add_tail to fix this.

Fixes: 660ba678f999 ("firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221111015326.251650-2-chenzhongjin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi-sysfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index 66727ad3361b9..402217c570333 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -603,16 +603,16 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 	*ret = kobject_init_and_add(&entry->kobj, &dmi_sysfs_entry_ktype, NULL,
 				    "%d-%d", dh->type, entry->instance);
 
-	if (*ret) {
-		kobject_put(&entry->kobj);
-		return;
-	}
-
 	/* Thread on the global list for cleanup */
 	spin_lock(&entry_list_lock);
 	list_add_tail(&entry->list, &entry_list);
 	spin_unlock(&entry_list_lock);
 
+	if (*ret) {
+		kobject_put(&entry->kobj);
+		return;
+	}
+
 	/* Handle specializations by type */
 	switch (dh->type) {
 	case DMI_ENTRY_SYSTEM_EVENT_LOG:
-- 
2.39.2



