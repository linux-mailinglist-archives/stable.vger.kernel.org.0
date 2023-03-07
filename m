Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FCD6AF460
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjCGTQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbjCGTQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF26DCDA09
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7134961535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE7FC433EF;
        Tue,  7 Mar 2023 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215591;
        bh=74ixLvaz9Go/gDxr3wBRo/9Pn/kQ5m6yyXPWiIUliu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2GXwtw1ya8DAOEeJic2Ph/9Png9Q1S+iwYHB2aTDdXaa9NCIXYPeZIuyXAjvcetD
         GAAcpvPgQRWqu0NW4+BCtc63a8SOUtx8ggEz/aqd3gsyPFmomma/kL/1FfhiUUGCxO
         gGy5G16k7VQnFkTpz0yrZQGRikAmrp/NYd7e/x1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/567] firmware: dmi-sysfs: Fix null-ptr-deref in dmi_sysfs_register_handle
Date:   Tue,  7 Mar 2023 18:00:47 +0100
Message-Id: <20230307165919.350124124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 4a93fb490cb46..3d57b08320df9 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -602,16 +602,16 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
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



