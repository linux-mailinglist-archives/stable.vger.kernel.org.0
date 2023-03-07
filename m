Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391B76AEAE9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjCGRid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjCGRiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8FF94A5E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC026151D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83476C4339C;
        Tue,  7 Mar 2023 17:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210440;
        bh=gfONuWEebLiMUwQloAWvwxGVe151Wz9OjS/itLDjZN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eu+bnU0ZhDHQdH594kZc4qPxhTnBGSWQJ7Hlyfb8yMHDo1huM+EV2W/Z22VFzizCD
         Uvcs9E9jmbgHWh9cxEMwSpnOvY4iQ4Gai/Gz6VYBdexowCojWIqdEYcJaEh3Lg7Y2j
         dVFvx6OKhywN4ILYOS713+4W8+dkESWuMAxiInW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0524/1001] driver core: fix resource leak in device_add()
Date:   Tue,  7 Mar 2023 17:54:56 +0100
Message-Id: <20230307170044.195004837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 506289e6b04dd..9fccf7b4e7ea3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3413,7 +3413,7 @@ int device_add(struct device *dev)
 	/* we require the name to be set before, and pass NULL */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
 	if (error) {
-		glue_dir = get_glue_dir(dev);
+		glue_dir = kobj;
 		goto Error;
 	}
 
-- 
2.39.2



