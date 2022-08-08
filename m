Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B97B58C80F
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 14:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiHHMBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 08:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiHHMBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 08:01:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D601C2
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 05:01:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gk3so16118199ejb.8
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 05:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=QQuvS03wLPNAA2N7mrnjGQ8WmG7uuggCIN8Wr1MEK3c=;
        b=aZsPLEmBrMKaaqOCBBm9DH/2PapmR+vPbC89o8FzEVhBYYvw2kMuxxiXGIfF2cGzVu
         alBHbw7Z056QYAmR74fkURtiV7WDeMLqYNY23bgIKhQi/UBsjzdhKb/dpwFH75PMhj/d
         gFJHB+X+WdYNISMeeLg/39uZXPYO6FdSVebjfxCky4dVB8SThtnzkc3YjFvz+iNwWiDt
         +LgLw4Ly6VEipSEUp+67CldAroeEt2+J+LIrx+wBxGChbY/3WEeyuZoHp6YdRsbRdgzG
         qWx7zk4N9b38NoCaMjjq76HXO919HaHf3RNBG+JTTH4eWn3C1G+mml5/kpGZA0vQX8DV
         x5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=QQuvS03wLPNAA2N7mrnjGQ8WmG7uuggCIN8Wr1MEK3c=;
        b=T7BcUPGM3AxAoljmVyZPwUM7PZ1sK1GFwhGAp9Ye4jpZHJ/WYanfJZfxoV4JY1pzBq
         4mstGRh2mpt7mX0w/BT4bHm7+Sp2yJjha7CFkkC5eT8ecyPHuadgp36FVXZSVDZ1eEaZ
         8N1w8WrRqd+Zprgk9YIEdX6AWd3qTxwC1CvRdyZv5idCXBXXO+DIeSyc2IspKce9HzTh
         oleAG3bIly1mGS9SAFDBOFQW+rspP0gQnq/wIGmLQXpV3yxAxCFE6ocm7KvoUq5e0TDJ
         v0nFXcDnCPjvc97jvCZ5kXoyx5YxpnkYdSAgrqqpQrXtfxqN33y8W9MgEQMaVdOcH7vu
         BB4g==
X-Gm-Message-State: ACgBeo0c6CyHI724kLlJdh3NJzcoOVYwPaWaWFKZj80hGcURIPvgb5hB
        K7wmm5XnHNxqH7YDDBvw1pfPiNmYDwo=
X-Google-Smtp-Source: AA6agR7lVtELY4myuEOrsc3SyZgg13DQDor1kVt7K52J/3CDWfDDtrXUlykBERmoyLfRmF9rLEvskg==
X-Received: by 2002:a17:907:168e:b0:731:4ba0:d5e9 with SMTP id hc14-20020a170907168e00b007314ba0d5e9mr4832267ejc.204.1659960072550;
        Mon, 08 Aug 2022 05:01:12 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af044400b9d54df6b07d4ee8.dip0.t-ipconnect.de. [2003:f6:af04:4400:b9d5:4df6:b07d:4ee8])
        by smtp.googlemail.com with ESMTPSA id r13-20020a17090638cd00b007304924d07asm4962544ejd.172.2022.08.08.05.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 05:01:12 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 1/1] selinux: drop super_block backpointer from superblock_security_struct
Date:   Mon,  8 Aug 2022 13:59:22 +0200
Message-Id: <20220808115922.331003-2-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220808115922.331003-1-theflamefire89@gmail.com>
References: <20220808115922.331003-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit b159e86b5a2ab826b3a292756072f4cc523675ab upstream.

It appears to have been needed for selinux_complete_init() in the past,
but today it's useless.

Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
[AG: Backported to 4.9]
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
---
 security/selinux/hooks.c          | 5 ++---
 security/selinux/include/objsec.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index eb503eccbacc8..d446b501334ab 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -390,7 +390,6 @@ static int superblock_alloc_security(struct super_block *sb)
 	mutex_init(&sbsec->lock);
 	INIT_LIST_HEAD(&sbsec->isec_head);
 	spin_lock_init(&sbsec->isec_lock);
-	sbsec->sb = sb;
 	sbsec->sid = SECINITSID_UNLABELED;
 	sbsec->def_sid = SECINITSID_FILE;
 	sbsec->mntpoint_sid = SECINITSID_UNLABELED;
@@ -643,7 +642,7 @@ static int selinux_get_mnt_opts(const struct super_block *sb,
 		opts->mnt_opts_flags[i++] = DEFCONTEXT_MNT;
 	}
 	if (sbsec->flags & ROOTCONTEXT_MNT) {
-		struct dentry *root = sbsec->sb->s_root;
+		struct dentry *root = sb->s_root;
 		struct inode_security_struct *isec = backing_inode_security(root);
 
 		rc = security_sid_to_context(isec->sid, &context, &len);
@@ -699,7 +698,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	int rc = 0, i;
 	struct superblock_security_struct *sbsec = sb->s_security;
 	const char *name = sb->s_type->name;
-	struct dentry *root = sbsec->sb->s_root;
+	struct dentry *root = sb->s_root;
 	struct inode_security_struct *root_isec;
 	u32 fscontext_sid = 0, context_sid = 0, rootcontext_sid = 0;
 	u32 defcontext_sid = 0;
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index c21e135460a5e..e4ad5fa58c6b0 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -63,7 +63,6 @@ struct file_security_struct {
 };
 
 struct superblock_security_struct {
-	struct super_block *sb;		/* back pointer to sb object */
 	u32 sid;			/* SID of file system superblock */
 	u32 def_sid;			/* default SID for labeling */
 	u32 mntpoint_sid;		/* SECURITY_FS_USE_MNTPOINT context for files */
-- 
2.25.1

