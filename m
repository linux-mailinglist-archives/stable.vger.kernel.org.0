Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F207A1FAB39
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 10:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgFPIaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 04:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFPIav (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 04:30:51 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8771C05BD43;
        Tue, 16 Jun 2020 01:30:51 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d8so8056329plo.12;
        Tue, 16 Jun 2020 01:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7tdeRgfUrKswh73pt/8hvKWXrWSAEqX+hL5gmVdJslc=;
        b=WVYrFkdChaW6wX4uUhe2YweAwSrPz7Ai2FglsfN4vM9JqzkIUhxL8tdIguA+kyo92M
         pzd06rF8By4xTOcy90xrua9jbVSh/Ta8i3cutZ/CiGnTdpDjIljhx+fZV/fmIEFWmAED
         zuKRhYegPmJluLJSZ7tscVzl5InhIAaUuqQE98vEUN/y1tnhxTS6eucHCbYUuYPRyrsA
         2Cqm9vSbtzPdnkmJ9S8/LwkDEu1SBeVv/kVYXw8yT/fPPyMkihgXeYX4qwRQMMM3oFtD
         Eu0NNxNawF2sNbhtXwB9160R1WtK0pwhDhhHXLjImap7l/DEw9bOvqVuGlHW137Gpp5O
         nk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7tdeRgfUrKswh73pt/8hvKWXrWSAEqX+hL5gmVdJslc=;
        b=Y36N7at1iWBTPO6mftNAIS+y6q4n870e1x4BXDg+rPejnEVXX8Z+DcevvYGirla5Yx
         XKqrZFzSad3p0LPctWEy2NyKjQh5b8Tuxy0bwQgMlefz2IsxeTDwNa4/gQz1pTsAyMK/
         vRAS9bcOyE4AM8xxlzBK60P+whUjhZ0f71szXqU9xFxIG6+VRTPRyVG+26hqUgp64mec
         TixL4rlOGMQQ+rsWZ1pYqJN8my8AfnHPJYMdRo71Ml0c57CpVxZUhCKLP8GqyF84xP05
         NBRKULmkn3Xoz5qLOQkVuhEpc8X25SpZ5CxCpxc46FFwQfYYrEgxMdNp3cU8Assu27nZ
         pQOQ==
X-Gm-Message-State: AOAM530cB7aWLTnuN/QtihDDIaP4myrxzGLz1jXzFljcFMnU+WSSMCUf
        TUGqf2mInP+Jw5fqDIyijVM=
X-Google-Smtp-Source: ABdhPJw+vUuXBVXdxdPixEUWBdl54jeSPXqhfAAHT+DZOu2pszxCarRdjr28KdBCHVyVHNgAtljEKg==
X-Received: by 2002:a17:90b:3d7:: with SMTP id go23mr1692308pjb.157.1592296251224;
        Tue, 16 Jun 2020 01:30:51 -0700 (PDT)
Received: from her0gyu-virtual-machine.localdomain ([1.221.137.163])
        by smtp.gmail.com with ESMTPSA id u20sm17304847pfk.91.2020.06.16.01.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:30:50 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] ovl: inode reference leak in ovl_is_inuse true case.
Date:   Tue, 16 Jun 2020 17:30:43 +0900
Message-Id: <20200616083043.25801-1-her0gyugyu@gmail.com>
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

Again, Great thanks Amir. I revise my patch through your kind guidance.

