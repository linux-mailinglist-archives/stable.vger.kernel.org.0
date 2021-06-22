Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2263B0F3B
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 23:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhFVVIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 17:08:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38087 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhFVVIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 17:08:47 -0400
Received: from mail-qt1-f199.google.com ([209.85.160.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gpiccoli@canonical.com>)
        id 1lvnbJ-0003pq-V3
        for stable@vger.kernel.org; Tue, 22 Jun 2021 21:06:29 +0000
Received: by mail-qt1-f199.google.com with SMTP id k18-20020ac847520000b029024ec8734412so558902qtp.4
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 14:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+3tx47VkZzGMPaCHF7qW5QcIkp/22n92er5i6sylIgQ=;
        b=gzigTqfQPcKrl5Wr8JkJgITSecVWIxE/AAwVkFF4RzGRjIiW1sk9a3MgcSuqiReLJ8
         hCStXZxpy3H3sGiOpe97ziypmOPy9JGwCrZF52gK/khcMbO7N74rOH7DQDO0d+nDq3ch
         SsayYYg4KayV5VfoK8VKJDz2tZpbebdLg5NW//Wy9vXd7Irgv0SK+9sBJm/22dsTP5MR
         uSBb9olEJvM1LmEuHR/dcAk/UiezvOdlZs/dr6C1VeBT5pgdUcp3FnTkzEn3QI/sTTRr
         rESp84sJCGf66n3RBCj8SBdQU6bdEB7/+HrFgmqMD6JZ6pdGJqD7fhHGPzHwIA94A9hI
         K64g==
X-Gm-Message-State: AOAM530TrRjEYJkefxSQ0qnYmwkf0Z7WhYdSFlsUplX5CYXzxC6lGgVL
        uA+jWD/CjxC6nrcB3camo/53fFBC99BDSJ8MfIaKUpyrHqEqKBJnRVxCU8PcK20FMbvkCxcE2+y
        oLIeUBLOrC309oTzQYlAfbOlyESGv0YxUUA==
X-Received: by 2002:ac8:5f88:: with SMTP id j8mr684379qta.9.1624395989138;
        Tue, 22 Jun 2021 14:06:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhjw2KfzsAAUkIqgqp6s9X+Y7MLDQsgFDNOoNl5KJ39wH9AUDFOR3dykUcAXOxgnITztu3mw==
X-Received: by 2002:ac8:5f88:: with SMTP id j8mr684367qta.9.1624395988906;
        Tue, 22 Jun 2021 14:06:28 -0700 (PDT)
Received: from localhost ([187.183.41.59])
        by smtp.gmail.com with ESMTPSA id f19sm14415335qkg.70.2021.06.22.14.06.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 14:06:28 -0700 (PDT)
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
To:     stable@vger.kernel.org
Cc:     gpiccoli@canonical.com, viro@zeniv.linux.org.uk
Subject: [4.14.y][PATCH 2/2] unfuck sysfs_mount()
Date:   Tue, 22 Jun 2021 18:06:22 -0300
Message-Id: <20210622210622.9925-2-gpiccoli@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622210622.9925-1-gpiccoli@canonical.com>
References: <20210622210622.9925-1-gpiccoli@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7b745a4e4051e1bbce40e0b1c2cf636c70583aa4 upstream.

new_sb is left uninitialized in case of early failures in kernfs_mount_ns(),
and while IS_ERR(root) is true in all such cases, using IS_ERR(root) || !new_sb
is not a solution - IS_ERR(root) is true in some cases when new_sb is true.

Make sure new_sb is initialized (and matches the reality) in all cases and
fix the condition for dropping kobj reference - we want it done precisely
in those situations where the reference has not been transferred into a new
super_block instance.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---

I'd like to protest this patch title heheh
But I think it's better to keep consistency with upstream. It's the same
case as patch 1 of the series, no clear reason for its absence in stable.
Build-tested on x86-64 with defconfig.

Thanks,


Guilherme


 fs/sysfs/mount.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 20b8f82e115b..2bbe84d9c0a8 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -28,7 +28,7 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 {
 	struct dentry *root;
 	void *ns;
-	bool new_sb;
+	bool new_sb = false;
 
 	if (!(flags & MS_KERNMOUNT)) {
 		if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
@@ -38,9 +38,9 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
 	root = kernfs_mount_ns(fs_type, flags, sysfs_root,
 				SYSFS_MAGIC, &new_sb, ns);
-	if (IS_ERR(root) || !new_sb)
+	if (!new_sb)
 		kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
-	else if (new_sb)
+	else if (!IS_ERR(root))
 		root->d_sb->s_iflags |= SB_I_USERNS_VISIBLE;
 
 	return root;
-- 
2.31.1

