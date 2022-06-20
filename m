Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AE05519CF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244488AbiFTNFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244830AbiFTNEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B78192B6;
        Mon, 20 Jun 2022 05:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C75561449;
        Mon, 20 Jun 2022 12:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78914C3411B;
        Mon, 20 Jun 2022 12:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729926;
        bh=sNT+9tqr5huqBOqoeTeyLHCWgjIGaTKgwJ3WrQ79i+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aayacWws3If5BoCtRoqdFKUhOPGSgUAD+zGyWgjO1Z3D+EnI8K8485REzBgHA401W
         vnVyw0mGN/6H+lQwsY1iPP9o5F914YTSNzXc4NDDVSz0L9mqOwbXDNjw24ywhwssm2
         6OYumFse5OyKHJCR6+94ZXYitMOLDkH/Q0fet7Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.18 086/141] init: Initialize noop_backing_dev_info early
Date:   Mon, 20 Jun 2022 14:50:24 +0200
Message-Id: <20220620124732.088156973@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 4bca7e80b6455772b4bf3f536dcbc19aac424d6a ]

noop_backing_dev_info is used by superblocks of various
pseudofilesystems such as kdevtmpfs. After commit 10e14073107d
("writeback: Fix inode->i_io_list not be protected by inode->i_lock
error") this broke because __mark_inode_dirty() started to access more
fields from noop_backing_dev_info and this led to crashes inside
locked_inode_to_wb_and_lock_list() called from __mark_inode_dirty().
Fix the problem by initializing noop_backing_dev_info before the
filesystems get mounted.

Fixes: 10e14073107d ("writeback: Fix inode->i_io_list not be protected by inode->i_lock error")
Reported-and-tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reported-and-tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reported-and-tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/init.c         |  2 ++
 include/linux/backing-dev.h |  2 ++
 mm/backing-dev.c            | 11 ++---------
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/base/init.c b/drivers/base/init.c
index d8d0fe687111..397eb9880cec 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/memory.h>
 #include <linux/of.h>
+#include <linux/backing-dev.h>
 
 #include "base.h"
 
@@ -20,6 +21,7 @@
 void __init driver_init(void)
 {
 	/* These are the core pieces */
+	bdi_init(&noop_backing_dev_info);
 	devtmpfs_init();
 	devices_init();
 	buses_init();
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 87ce24d238f3..8c2eed1b69c1 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -121,6 +121,8 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 
 extern struct backing_dev_info noop_backing_dev_info;
 
+int bdi_init(struct backing_dev_info *bdi);
+
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @wb: bdi_writeback of interest
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7176af65b103..e262739a0a23 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -230,20 +230,13 @@ static __init int bdi_class_init(void)
 }
 postcore_initcall(bdi_class_init);
 
-static int bdi_init(struct backing_dev_info *bdi);
-
 static int __init default_bdi_init(void)
 {
-	int err;
-
 	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_UNBOUND |
 				 WQ_SYSFS, 0);
 	if (!bdi_wq)
 		return -ENOMEM;
-
-	err = bdi_init(&noop_backing_dev_info);
-
-	return err;
+	return 0;
 }
 subsys_initcall(default_bdi_init);
 
@@ -782,7 +775,7 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-static int bdi_init(struct backing_dev_info *bdi)
+int bdi_init(struct backing_dev_info *bdi)
 {
 	int ret;
 
-- 
2.35.1



