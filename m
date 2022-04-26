Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6277950F090
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbiDZGEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243283AbiDZGEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:04:22 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AB41AF31
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:01:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h1so17004338pfv.12
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwwHo+H2QBPRH3iTkT+m0A5KVecgbTlfdCVKWR+HKgQ=;
        b=ZTfmNhk18FlzdHE44AfVQrA0V0GkQs2kCjbhXzEe1IMqoyWq8KoE4ml1ChquFLjNEn
         22vGVAEdXsYnQU8e+97KrNGupuzSDl6X0t8bHtdHJ4Em/25x+4kBo4KDY8VsEhx8XF1r
         e4VG+5S032vemA8NXxeoT92HXdVIuPPOB6ZRRGw6zsZe47vzt60RBvO5pg1ywPAJyV2J
         JP7v202giNNbdvfflgvIsOdVv4q+KeHnE+4qYNA+JUrSgNmWpEqPgbb4yVwHS/FQ/5KF
         ez55Ib6XkOB9X646U8tpdgcPlZPdWTafpXqEEuUYhG9H9sa0qwM6r/QCte2CHLR6j8fY
         mkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwwHo+H2QBPRH3iTkT+m0A5KVecgbTlfdCVKWR+HKgQ=;
        b=wvagW0t+ZaQ4/zl1zU5DEigBLxbO5keBoO/9NDrOYJLWRFeGkgKhExxY73YW3oeyye
         LIDuwnj297np/EKWC5oM1DMVvfbfRGqopBHAOjN52JGeRZBCcA2xYZ15eSwwJd4k7UjL
         Op/dzFpjOdR8SYaKhK999XTMgA4MsBYLCyHKzYjVKDrOtfKlTBrCkDSFQihomxCKppeJ
         ur8Ggi9hccAEsV9Y2Ym6FuzilsAvyfkvXD7re8E1zz/F8MZ65wX86lzxL8zn5bCiLt8w
         ob4Up2p5AG7SdWLTa8dZ+IL8GcVMZ+VXOiwvIr+B9cIhVD3D5NrZnPihopd5xGD2MvDo
         XHbg==
X-Gm-Message-State: AOAM530L3heyiUN3n0XTXIoDE6ezKvuL76jbw8SaNxZBQOQXC85cvPOT
        uctlbENdKIH1w4SEkkm+gDMQ
X-Google-Smtp-Source: ABdhPJzweQORRnWXw4qqVANkJ05EPo+IV6KwlR2ZNFpjKbDp5SXrcPZPHaa0oWK4bW9NWTR5BuCDMA==
X-Received: by 2002:a63:2b97:0:b0:3aa:ffe8:b2da with SMTP id r145-20020a632b97000000b003aaffe8b2damr12163548pgr.194.1650952874519;
        Mon, 25 Apr 2022 23:01:14 -0700 (PDT)
Received: from localhost ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id o2-20020a62f902000000b0050cfb6994e2sm10879494pfh.130.2022.04.25.23.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 23:01:13 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     mcgrof@kernel.org, akpm@linux-foundation.org,
        oliver.sang@intel.com, virtualization@lists.linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH] vduse: Fix NULL pointer dereference on sysfs access
Date:   Tue, 26 Apr 2022 14:01:03 +0800
Message-Id: <20220426060103.104-1-xieyongji@bytedance.com>
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

The control device has no drvdata. So we will get a NULL
NULL pointer dereference when accessing control device's
msg_timeout via sysfs:

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

To fix it, let's add a NULL check in msg_timeout_show() and
msg_timeout_store().

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f85d1a08ed87..f1c42f4aabb4 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1268,6 +1268,9 @@ static ssize_t msg_timeout_show(struct device *device,
 {
 	struct vduse_dev *dev = dev_get_drvdata(device);
 
+	if (!dev)
+		return -EPERM;
+
 	return sysfs_emit(buf, "%u\n", dev->msg_timeout);
 }
 
@@ -1278,6 +1281,9 @@ static ssize_t msg_timeout_store(struct device *device,
 	struct vduse_dev *dev = dev_get_drvdata(device);
 	int ret;
 
+	if (!dev)
+		return -EPERM;
+
 	ret = kstrtouint(buf, 10, &dev->msg_timeout);
 	if (ret < 0)
 		return ret;
-- 
2.20.1

