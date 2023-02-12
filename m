Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4C169369D
	for <lists+stable@lfdr.de>; Sun, 12 Feb 2023 10:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBLJCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 04:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBLJCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 04:02:20 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406411285D;
        Sun, 12 Feb 2023 01:02:19 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id u10so6715909wmj.3;
        Sun, 12 Feb 2023 01:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pk+oc1hsh2TSClg1xP7U0cUnPuJfRC0l/Fq4XZqAhn0=;
        b=QCHyCvQNYjTamJMZMwkXgyoMljlmEtcIPcO9Sg5nbALgTeNg+sZjejraWJYdUrXTh4
         mCqyoPaAEj3uy+kVQbpyKa1jkN5GjxdQpQpkhwV5Kva5if8bQ9C0uPPYmYlc0BMc6cqW
         BW+mvUUPtfAk75oLWntrHw1DcxaZhlhjCmtZ0wS11kuV2thD6kwSyR4VlHofrRsUoA39
         TvaUTrx/JpuGztlQTSDxUGQBp+rF18eoWJjzYW2zwzLxn57mqfxpmSH6q3FpN72Jnpnt
         AmF4RQ0MtK7o/mk2yliYr628eOzcMzzf/2JM91/XUCKXbdWsoRGXD0vO988t4s/l9Rtj
         2Mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pk+oc1hsh2TSClg1xP7U0cUnPuJfRC0l/Fq4XZqAhn0=;
        b=8AVZwykLxL38DG1U3dMyebkL8+qDzk2C2b7HFCpsVBVuc4xtdsks5YYJeuy8S94+V0
         +wbTtsvcaMlrkm5T4ARSyJ7O8zvG8P1ZMeHU6Vu2uRg2k3Rz+PT/IZ2vIcEGkmoiWxp0
         v7HI4gYxhaYZlJa5N8AVkLz0LN812WN79b46Nd60z0G2h18i0QrzfYbS+h0Gm4WWbV9q
         q7M8Rdu4eGf9OiN41JLCCyICQLVbU6rpDSTCR2LJ010IKUK3YSDDSycrc8sTNHa2vWng
         e8ci45SNMYObxNruZvcd13qWrH67MIODf6kKjZ8RtNrIq/9cOTcYgV9K9naAv1IcTh1k
         gQ+w==
X-Gm-Message-State: AO0yUKVMGm1tygVOgP8G9BjO8JgmH/hOjkwXph+t849j+3VDeW3l06w6
        oliuygdGUnZgJjguLPjWpCM=
X-Google-Smtp-Source: AK7set+HdHaaf6bDoYx3Lp2SzT8Gh41OoFaveimhDY8sR+W5xzAeFVhoLM/RY5s6YdwRSQVLFbw41A==
X-Received: by 2002:a05:600c:1609:b0:3dc:4316:52be with SMTP id m9-20020a05600c160900b003dc431652bemr2222798wmn.10.1676192538877;
        Sun, 12 Feb 2023 01:02:18 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c450700b003dc42d48defsm12017183wmo.6.2023.02.12.01.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 01:02:18 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 2/2] ovl: remove privs in ovl_fallocate()
Date:   Sun, 12 Feb 2023 11:02:04 +0200
Message-Id: <20230212090204.339226-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230212090204.339226-1-amir73il@gmail.com>
References: <20230212090204.339226-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 23a8ce16419a3066829ad4a8b7032a75817af65b upstream.

Underlying fs doesn't remove privs because fallocate is called with
privileged mounter credentials.

This fixes some failure in fstests generic/683..687.

Fixes: aab8848cee5e ("ovl: add ovl_fallocate()")
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 259b2d41b707..0e734c8b4dfa 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -531,9 +531,16 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	const struct cred *old_cred;
 	int ret;
 
+	inode_lock(inode);
+	/* Update mode */
+	ovl_copyattr(ovl_inode_real(inode), inode);
+	ret = file_remove_privs(file);
+	if (ret)
+		goto out_unlock;
+
 	ret = ovl_real_fdget(file, &real);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = vfs_fallocate(real.file, mode, offset, len);
@@ -544,6 +551,9 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 
 	fdput(real);
 
+out_unlock:
+	inode_unlock(inode);
+
 	return ret;
 }
 
-- 
2.34.1

