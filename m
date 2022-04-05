Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7794F25E4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiDEHwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbiDEHvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DDA15FCE;
        Tue,  5 Apr 2022 00:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 536E1B81B16;
        Tue,  5 Apr 2022 07:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF38C340EE;
        Tue,  5 Apr 2022 07:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144866;
        bh=mGhEYJ4MRQnLh6v5RiaaG7E7v7Noa+l8RLrSLj5X2Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAphMs2GSidxR19rQMvU5v9NsBjMPu2VJyKrjhTGhuVevtc0JO/2eVgEy8ql9DLi3
         oYozmYI0ED3wfygQN8oU8AIgOYjFBWC2BJeDT/G7+HqPtvTKX+8cyRjFgDEKAHbuas
         HkWb4b54I8Ga1UQen0eAmQIMc83s725MuVgQmbxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "GONG, Ruiqi" <gongruiqi1@huawei.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, GONG@vger.kernel.org
Subject: [PATCH 5.17 0199/1126] selinux: access superblock_security_struct in LSM blob way
Date:   Tue,  5 Apr 2022 09:15:46 +0200
Message-Id: <20220405070413.448610385@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: GONG, Ruiqi <gongruiqi1@huawei.com>

[ Upstream commit 0266c25e7c2821181b610595df42cbca6bc93cb8 ]

LSM blob has been involved for superblock's security struct. So fix the
remaining direct access to sb->s_security by using the LSM blob
mechanism.

Fixes: 08abe46b2cfc ("selinux: fall back to SECURITY_FS_USE_GENFS if no xattr support")
Fixes: 69c4a42d72eb ("lsm,selinux: add new hook to compare new mount to an existing mount")
Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5b6895e4fc29..a0243bae8423 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -479,7 +479,7 @@ static int selinux_is_sblabel_mnt(struct super_block *sb)
 
 static int sb_check_xattr_support(struct super_block *sb)
 {
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec = selinux_superblock(sb);
 	struct dentry *root = sb->s_root;
 	struct inode *root_inode = d_backing_inode(root);
 	u32 sid;
@@ -2647,7 +2647,7 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
 static int selinux_sb_mnt_opts_compat(struct super_block *sb, void *mnt_opts)
 {
 	struct selinux_mnt_opts *opts = mnt_opts;
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec = selinux_superblock(sb);
 	u32 sid;
 	int rc;
 
-- 
2.34.1



