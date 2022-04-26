Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B401850F2A7
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 09:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiDZHjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 03:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344069AbiDZHje (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 03:39:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB70DF0E
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 00:36:27 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k29so15384403pgm.12
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 00:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9+nwgx+J2+Z/l/1a7SY07FV9s5JE+creAo84TWU2hI=;
        b=Wf3N2hlLHgdfH+UqVRGIl6e9mipSnPtXKVmeb2DOjTC3OrxqDzW5bqTlnYUSH5JDuz
         0xI2JLRF72qiBRUqvbLUQsaeddKJpFPbgVZ1vZ/RTj91EvaFjpkHywH/kJrkqN2e7ei7
         ItU5W8ySKC6izSy1XQEsSiCE0t8A4b/QSW+R50M5a7jf2I8yoBl4NNRj7ZTuihYwApq8
         Dy2nJFSl7V6PmCUbGTr8DKuqUEezlDVSjgOGIW0slMeqooSS0swiSVp3Wrqf3/djCh3C
         H8a2nzjQdIQwPfA0XXOjDJ1zHKylGqYsnWQ3GCmw8r1mJXUvueNIIOZKVLRfSde9Qkip
         GC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9+nwgx+J2+Z/l/1a7SY07FV9s5JE+creAo84TWU2hI=;
        b=31PhE96Rrjg1ofHagCOzKADX2wnvpMvvThe68vsmlnu+sBI5wSRNXK9LlHL0s9vlv5
         8U6No+U89BGIaH07lukbYwjSoZEbOTZTrtbwWcqILqNK0416UCoLSmByZQm2KTn0RbHQ
         fNKv+LKKDGEUMFrPSq4RVgyz9eWtUX5sLsGO0KfKZg0oswolxgDE/xsDwFLZq4bgyKdV
         Od2JlYxkCnbtLk436E2QK9Ndv+5LHeHOJEll4YTWAziUQ7MKn6v8S40OFGOnSTrmOu78
         ZgY6rtkJ7N3iIfb1wuQp5wCNFCy/UU2R7YIOqIcwxxAhGnWtdkBs4JnwNSmE1cG5/HP/
         /49g==
X-Gm-Message-State: AOAM531XzlIK+P+CZOXMii6mKolAbqv+vZTAmt99pyQG6mXaikLcyNf6
        aIGlR7mEhX7t5ugyjAyp7v8OG1Yqlarm
X-Google-Smtp-Source: ABdhPJzkUZvKOdPEskZMk4EQOTk2Zw7QI5+b7GijqapYB1PUHBJJhAcOIa/KIoqRoPDxFCqz9GPgog==
X-Received: by 2002:a63:1d5f:0:b0:39d:b5e4:ae24 with SMTP id d31-20020a631d5f000000b0039db5e4ae24mr18078693pgm.502.1650958587183;
        Tue, 26 Apr 2022 00:36:27 -0700 (PDT)
Received: from localhost ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id j22-20020a17090a589600b001d93ed0d97csm1699056pji.45.2022.04.26.00.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 00:36:25 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, gregkh@linuxfoundation.org
Cc:     mcgrof@kernel.org, akpm@linux-foundation.org,
        oliver.sang@intel.com, virtualization@lists.linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Date:   Tue, 26 Apr 2022 15:36:56 +0800
Message-Id: <20220426073656.229-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f85d1a08ed87..160e40d03084 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
 
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
@@ -1595,7 +1595,6 @@ static int vduse_init(void)
 		return PTR_ERR(vduse_class);
 
 	vduse_class->devnode = vduse_devnode;
-	vduse_class->dev_groups = vduse_dev_groups;
 
 	ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
 	if (ret)
-- 
2.20.1

