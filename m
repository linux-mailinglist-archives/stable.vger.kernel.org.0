Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09486AF03E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjCGS3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjCGS3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10713B04AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3982B819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9966C433EF;
        Tue,  7 Mar 2023 18:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213328;
        bh=QRGl7fXeWIu6gR1tYWtmt3+i2PPoawwV5CI74lPQsxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k183g3sJtDh6GWwutl/i4Ev7J7qw1rEeFWMB5PXih990ExaEMZOqiu+muGCY/kb2T
         VfGBed9+ugp90BTnusYpHGsx3wYuGHvofSiMNVYWAU+z31GOJXtJ3zL8OwJTMRMC1+
         1QopuS7wA9iy+eB2Pv5O6gxFX5I4oa+vD1CofN2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 442/885] driver core: fix resource leak in device_add()
Date:   Tue,  7 Mar 2023 17:56:16 +0100
Message-Id: <20230307170021.629372627@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 6977b1a5d67097eaa4d02b0c126c04cc6e8917c0 ]

When calling kobject_add() failed in device_add(), it will call
cleanup_glue_dir() to free resource. But in kobject_add(),
dev->kobj.parent has been set to NULL. This will cause resource leak.

The process is as follows:
device_add()
	get_device_parent()
		class_dir_create_and_add()
			kobject_add()		//kobject_get()
	...
	dev->kobj.parent = kobj;
	...
	kobject_add()		//failed, but set dev->kobj.parent = NULL
	...
	glue_dir = get_glue_dir(dev)	//glue_dir = NULL, and goto
					//"Error" label
	...
	cleanup_glue_dir()	//becaues glue_dir is NULL, not call
				//kobject_put()

The preceding problem may cause insmod mac80211_hwsim.ko to failed.
sysfs: cannot create duplicate filename '/devices/virtual/mac80211_hwsim'
Call Trace:
<TASK>
dump_stack_lvl+0x8e/0xd1
sysfs_warn_dup.cold+0x1c/0x29
sysfs_create_dir_ns+0x224/0x280
kobject_add_internal+0x2aa/0x880
kobject_add+0x135/0x1a0
get_device_parent+0x3d7/0x590
device_add+0x2aa/0x1cb0
device_create_groups_vargs+0x1eb/0x260
device_create+0xdc/0x110
mac80211_hwsim_new_radio+0x31e/0x4790 [mac80211_hwsim]
init_mac80211_hwsim+0x48d/0x1000 [mac80211_hwsim]
do_one_initcall+0x10f/0x630
do_init_module+0x19f/0x5e0
load_module+0x64b7/0x6eb0
__do_sys_finit_module+0x140/0x200
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
</TASK>
kobject_add_internal failed for mac80211_hwsim with -EEXIST, don't try to
register things with the same name in the same directory.

Fixes: cebf8fd16900 ("driver core: fix race between creating/querying glue dir and its cleanup")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221123012042.335252-1-shaozhengchao@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e5c15061070b7..9019b81405bf2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3451,7 +3451,7 @@ int device_add(struct device *dev)
 	/* we require the name to be set before, and pass NULL */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
 	if (error) {
-		glue_dir = get_glue_dir(dev);
+		glue_dir = kobj;
 		goto Error;
 	}
 
-- 
2.39.2



