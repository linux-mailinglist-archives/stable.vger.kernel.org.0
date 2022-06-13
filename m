Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D594E548AFA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376268AbiFMNVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377080AbiFMNUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7630969CD2;
        Mon, 13 Jun 2022 04:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C61F961036;
        Mon, 13 Jun 2022 11:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0909C34114;
        Mon, 13 Jun 2022 11:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119355;
        bh=9yTrZd1tTo7lkmuhZLIBbWQ8EWpTWQx/plwALCaKlq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xc7AIo7n+YssxHG/xrzxXYbXRuxS2CR4bOT4eeDPgQEr4m0h64ohQTd9NRfW+WvUa
         /vxNY8Z2kkPvIB2Nou/kRzJ0Ua8cocI/Zc21NTAvy/3MwzKXZkPWQDiZVTyUzOZKt4
         MUod5jAnlzis53K1IRKV9jZ/mzqt7LfRolKlG5j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 233/247] vduse: Fix NULL pointer dereference on sysfs access
Date:   Mon, 13 Jun 2022 12:12:15 +0200
Message-Id: <20220613094930.011057293@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

commit b27ee76c74dc831d6e092eaebc2dfc9c0beed1c9 upstream.

The control device has no drvdata. So we will get a
NULL pointer dereference when accessing control
device's msg_timeout attribute via sysfs:

[ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
[ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
[ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
[ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
[ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
[ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
[ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
[ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
[ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
[ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
[ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
[ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
[ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
[ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
[ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
[ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
[ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)

To fix it, don't create the unneeded attribute for
control device anymore.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Message-Id: <20220426073656.229-1-xieyongji@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1336,9 +1336,9 @@ static int vduse_create_dev(struct vduse
 
 	dev->minor = ret;
 	dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
-	dev->dev = device_create(vduse_class, NULL,
-				 MKDEV(MAJOR(vduse_major), dev->minor),
-				 dev, "%s", config->name);
+	dev->dev = device_create_with_groups(vduse_class, NULL,
+				MKDEV(MAJOR(vduse_major), dev->minor),
+				dev, vduse_dev_groups, "%s", config->name);
 	if (IS_ERR(dev->dev)) {
 		ret = PTR_ERR(dev->dev);
 		goto err_dev;
@@ -1585,7 +1585,6 @@ static int vduse_init(void)
 		return PTR_ERR(vduse_class);
 
 	vduse_class->devnode = vduse_devnode;
-	vduse_class->dev_groups = vduse_dev_groups;
 
 	ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
 	if (ret)


