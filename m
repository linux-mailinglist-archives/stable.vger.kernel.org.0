Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5BF1FA948
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFPG6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 02:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgFPG6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 02:58:04 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB95C05BD43;
        Mon, 15 Jun 2020 23:58:04 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so9053999pfn.3;
        Mon, 15 Jun 2020 23:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6JCx3M5NEW2BTFXqOQ/NsV4+xAVLvv1Xfdrc5pPhPgI=;
        b=EP2+4uPv0cn31GchHsQAiYN7AC70iK3shVPS43R/pi8aBwSYft4bzY0+JaLzjVd+Uk
         uOGvEbYFuNrpQjl4Uio39diXwdFxPGkWmQXmZGAheecSVE29GnBLLCWqVsEhpIlEsgiJ
         sWsOOc/4FFxm9fV/t49DOGiNEd4uNN/tp1u2UB7Vb6KiOOAoy0jbghNhfyfdTDt+/mrG
         NsGLlIfPKV/LI2NtAvPrRc3DpTfEpkvlZs9JrgIbWMQvExU8qCnH8hR9ijZ7XDy+pJwX
         8ewXoyXxt6uPHzpvV79HL0epKuy6h6K3/ujCnReqs59XBM0ZQSAkcPHAc1xPEAJDgRbm
         +QxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6JCx3M5NEW2BTFXqOQ/NsV4+xAVLvv1Xfdrc5pPhPgI=;
        b=JIgzbikqfOv0cPh/aXEh+6PnFlv6TYD3V+kIQg1JBuBpH5WQR8g61EvRNyMU8bMKCO
         09WxJsDsN9D/Dw1YUiLetejZubu1eA10GK7tSGLjqeQcX8y4mGLJHN1meT5PqjvuMunP
         Yb95yHNINEdOAn4O2weoKk42RXkmJnj78XGhTBvFja3QKhqGSulBR6rCL8jHkyODN2H8
         V4SsXdzuIwDFqTqbJN8cpDGF8MlAbiw8fIftpg0ES8eexqD6UXcrY/Z9pnDrN+ku1hvA
         5Fwi6i5oxE+4d8eOV0HKdxPLhtUHqiv+Vochy0vBOPuZESJWKyA7S30DclVraapT4Hdq
         l/zw==
X-Gm-Message-State: AOAM532AZnRjotCeyOVCEiunHSgWlkZTQE4plq3WEOjrW/uRbcSGimaN
        ulbNjynVO3ZxV0yekbe9MAo=
X-Google-Smtp-Source: ABdhPJyPux959SxdWAHKbXLtEqM/atAW0E0/KdAV7MRRDbGH6069ejjGBkRtWqPhuVeNcJnTiwO5Og==
X-Received: by 2002:a63:de56:: with SMTP id y22mr964268pgi.398.1592290683672;
        Mon, 15 Jun 2020 23:58:03 -0700 (PDT)
Received: from her0gyu-virtual-machine.localdomain ([1.221.137.163])
        by smtp.gmail.com with ESMTPSA id d3sm15298701pfh.157.2020.06.15.23.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 23:58:02 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] ovl: inode reference leak in ovl_is_inuse true case.
Date:   Tue, 16 Jun 2020 15:57:56 +0900
Message-Id: <20200616065756.20140-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200615155645.32939-1-her0gyugyu@gmail.com>
References: <20200615155645.32939-1-her0gyugyu@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When "ovl_is_inuse" true case, trap inode reference not put.
plus adding the comment explaining sequence of
ovl_is_inuse after ovl_setup_trap.

Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers..")
Cc: <stable@vger.kernel.org> # v4.19+
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>
> ---
>  fs/overlayfs/super.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..0396793dadb8 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1029,6 +1029,12 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
>         NULL
>  };
>
> +/*
> + * Check if lower root conflicts with this overlay layers before checking
> + * if it is in-use as upperdir/workdir of "another" mount, because we do
> + * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
> + * in-use by our upperdir/workdir.
> + */

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 91476bc422f9..3097142b1e23 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1493,14 +1493,22 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		if (err < 0)
 			goto out;
 
+		/*
+		 * Check if lower root conflicts with this overlay layers before checking
+		 * if it is in-use as upperdir/workdir of "another" mount, because we do
+		 * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
+		 * in-use by our upperdir/workdir.
+		 */
 		err = ovl_setup_trap(sb, stack[i].dentry, &trap, "lowerdir");
 		if (err)
 			goto out;
 
 		if (ovl_is_inuse(stack[i].dentry)) {
 			err = ovl_report_in_use(ofs, "lowerdir");
-			if (err)
+			if (err) {
+				iput(trap);
 				goto out;
+			}
 		}
 
 		mnt = clone_private_mount(&stack[i]);
-- 
2.17.1

Great thanks Amir. guidance to me really helpful.
As you comment, I modified my patch.

1) I revised three patch so version is 3.
2) I misunderstood your comment(adding annotation) firstly. 
But, I clearly know at now and modified it.
the annotation before "ovl_setup_trap" is clearly understood as I see.

And I have some questions.

1) As I understand, The CC you said valid is 'linux-unionfs'?
2) The comment "Please add these lines to the bottom of commit message..."
   Is it needed manually when I revised patch?
