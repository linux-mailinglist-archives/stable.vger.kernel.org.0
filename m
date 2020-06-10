Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF071F505B
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 10:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgFJIdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 04:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgFJIdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 04:33:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8240C03E96F
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 01:33:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ne5so565244pjb.5
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 01:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=viTnGVmiLyU57YRhDhN8zDuiG6dPY/rXax8ClQE3VoA=;
        b=W1K849gsI1lcFSTB6RepoxDrdXeWXaq0G9ZXRaizv5Xh+XgQ/C+aBDCr+Lxx3C7h4y
         Vo25apgtLyuhLzGSMUs+Fy1iJmYpwqcxZ4/dAMVYUWOpe1xfThgrSJzr+MMKEm0eNdAU
         gakVOHPK4Gg6cpkKhqYdj+ls4TpFbzvpKv8qzN6x8MOM+C3ojLHAEb1my8N1Wjlhltuq
         xHHla5tPWw329KPgQHTAKdZ0upvMyblU44f3ZxHoi/Q16BUHaxbNIzoE79xuvjVfG7ke
         OBJOvIvRzLuqpyAoPZXHM/ZS5OWKV8XRTZ5ftFnxGkSlegROCIe4wey93YwW98cK34OJ
         I/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=viTnGVmiLyU57YRhDhN8zDuiG6dPY/rXax8ClQE3VoA=;
        b=Le4fASAYD1x4MpqRX/3KvpaV32VWf6MPk2DGTgauqyu77BxE5KsiQVjkkhFOZsbny5
         PVl+I1Ec/r9+eysqkrB7YuEoYgMiBlzyoUxXadyoelosI8YZ2uVRyaFhirz4pKB1N8GH
         sqP7QtFsohk5Sm5DMD6C+S3SoWKAishrRCr82xDedKEPt2K/4Pyhrt+jjehY2ImSBK9c
         KvTzokSVPu5nYIM4EyS5VEF3yUPt+iFhpHCeTOxwNaWULUs4UBNDQIrQWF3vHPdv2c4w
         pb7YqtDzyToh7yul/iFXDuAF29A7vXtRfs7XW+gQ/H2FWJ947fBtRcpLVNcgytYWC0qo
         1cmQ==
X-Gm-Message-State: AOAM530vqoTYDRr6SX0sEnLQtmbpW3QC4aeH//kJ4yArVvzjy8rn3tz4
        trPJEdRyPqePZLbz6nlJgH99aQ==
X-Google-Smtp-Source: ABdhPJwfZ7TDmgfra7WP8ts+VSQ6aJltH1PLOXX3lLF1IcXFnAO/Bem91V9zrOxF2Zp3LKeY29dLIw==
X-Received: by 2002:a17:90b:190e:: with SMTP id mp14mr1931900pjb.198.1591778023046;
        Wed, 10 Jun 2020 01:33:43 -0700 (PDT)
Received: from nagraj.local ([49.206.21.239])
        by smtp.gmail.com with ESMTPSA id w18sm12231562pfq.121.2020.06.10.01.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 01:33:42 -0700 (PDT)
From:   Sumit Semwal <sumit.semwal@linaro.org>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Chenbo Feng <fengc@google.com>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] dma-buf: Move dma_buf_release() from fops to dentry_ops
Date:   Wed, 10 Jun 2020 14:03:33 +0530
Message-Id: <20200610083333.455-1-sumit.semwal@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Charan Teja reported a 'use-after-free' in dmabuffs_dname [1], which
happens if the dma_buf_release() is called while the userspace is
accessing the dma_buf pseudo fs's dmabuffs_dname() in another process,
and dma_buf_release() releases the dmabuf object when the last reference
to the struct file goes away.

I discussed with Arnd Bergmann, and he suggested that rather than tying
the dma_buf_release() to the file_operations' release(), we can tie it to
the dentry_operations' d_release(), which will be called when the last ref
to the dentry is removed.

The path exercised by __fput() calls f_op->release() first, and then calls
dput, which eventually calls d_op->d_release().

In the 'normal' case, when no userspace access is happening via dma_buf
pseudo fs, there should be exactly one fd, file, dentry and inode, so
closing the fd will kill of everything right away.

In the presented case, the dentry's d_release() will be called only when
the dentry's last ref is released.

Therefore, lets move dma_buf_release() from fops->release() to
d_ops->d_release().

Many thanks to Arnd for his FS insights :)

[1]: https://lore.kernel.org/patchwork/patch/1238278/

Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> [5.3+]
Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: Charan Teja Reddy <charante@codeaurora.org>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/dma-buf/dma-buf.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 01ce125f8e8d..92ba4b6ef3e7 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -54,8 +54,11 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
 			     dentry->d_name.name, ret > 0 ? name : "");
 }
 
+static void dma_buf_release(struct dentry *dentry);
+
 static const struct dentry_operations dma_buf_dentry_ops = {
 	.d_dname = dmabuffs_dname,
+	.d_release = dma_buf_release,
 };
 
 static struct vfsmount *dma_buf_mnt;
@@ -77,14 +80,14 @@ static struct file_system_type dma_buf_fs_type = {
 	.kill_sb = kill_anon_super,
 };
 
-static int dma_buf_release(struct inode *inode, struct file *file)
+static void dma_buf_release(struct dentry *dentry)
 {
 	struct dma_buf *dmabuf;
 
-	if (!is_dma_buf_file(file))
-		return -EINVAL;
+	if (dentry->d_op != &dma_buf_dentry_ops)
+		return;
 
-	dmabuf = file->private_data;
+	dmabuf = dentry->d_fsdata;
 
 	BUG_ON(dmabuf->vmapping_counter);
 
@@ -110,7 +113,6 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	module_put(dmabuf->owner);
 	kfree(dmabuf->name);
 	kfree(dmabuf);
-	return 0;
 }
 
 static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
@@ -412,7 +414,6 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
 }
 
 static const struct file_operations dma_buf_fops = {
-	.release	= dma_buf_release,
 	.mmap		= dma_buf_mmap_internal,
 	.llseek		= dma_buf_llseek,
 	.poll		= dma_buf_poll,
-- 
2.27.0

