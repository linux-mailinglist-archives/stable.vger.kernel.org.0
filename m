Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B445453FEC0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 14:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243709AbiFGM1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 08:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiFGM10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 08:27:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC19B7F0
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 05:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EAC961786
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 12:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB4EC34114;
        Tue,  7 Jun 2022 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654604843;
        bh=WXbvREYNWCTpYckfz1AN9Cqnc1Fnx3zGw/aKWw60koo=;
        h=From:To:Cc:Subject:Date:From;
        b=BYnGUCN9hXYipt7ByVKxOgZyKgR8KVHCSU35TbPO8p2m73d6R5o/soqApOG5gSU6l
         5QYKVHR/l2dFwafLEC5OwnlOIw+xux3v8K+kjqCxMzoTHXTu4BNzbKfQf59aTBR9Ov
         ZA/K8AHH2JTcFz//4RCtUtWLvL7b13rk3zAfH9Dn3dVwqelYu3sfBI6fsMFCUYt2PG
         EVTQOy8WAcylqjDTj2ovqJciaNRrjUQY1l3CRLzYElxvTtzn2pTBYW2ELbFoeU2a3z
         IM2HQLZ72cRdB/DFCZR30LE0i8S/pUU3qERwgkTB6SRBxf+8/cbPDG2etSHR9lJ+iE
         WVOgTV72BMGDg==
From:   Christian Brauner <brauner@kernel.org>
To:     Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Christian Brauner <brauner@kernel.org>,
        tomoyo-dev-en@lists.osdn.me, stable@vger.kernel.org
Subject: [PATCH] tomoyo: fix handling of path{1,2}.parent.* conditions
Date:   Tue,  7 Jun 2022 14:27:16 +0200
Message-Id: <20220607122716.1704591-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2380; h=from:subject; bh=WXbvREYNWCTpYckfz1AN9Cqnc1Fnx3zGw/aKWw60koo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTNd+EK59d8VnVDzejztVfJ6555NPu9C2v0u73gUd7jxSqy Pu9vdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEmZfhf4zBkd9He4SnGi/QUzG8MZ nrj3acjGhfuVPxt3rni4slyhgZ7icH9ay9HBlWKM0l2x911uyZvYJIn5TV8ykXTh6ZOPMPPwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
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

When path conditions are specified tomoyo tries to retrieve information about
the parent dentry. It currently assumes that the parent dentry is always
reachable from the child dentry's mount. This assumption is wrong when
bind-mounts are in play:

mkdir /foo
touch /foo/file1

mkdir /bar
touch /bar/file2

mount --bind /bar/file2 /foo/file1

file read /foo/file1 path1.parent.uid=12

Tomoyo will now call dget_parent(file1). This will yield "bar". But "bar" isn't
reachable from the bind-mount of "file1". Handle this case by ensuring that the
parent dentry is actually reachable from the child dentry's mount and if not
skip it.

Fixes: 8761afd49ebf ("TOMOYO: Allow using owner/group etc. of file objects as conditions.")
Cc: stable@vger.kernel.org # 4.9+
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: tomoyo-dev-en@lists.osdn.me
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
Hey everyone,

Spotted this while working on some other fixes.
Just an fyi, I'm not subscribed on the mailing list.

Thanks!
Christian
---
 security/tomoyo/condition.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/security/tomoyo/condition.c b/security/tomoyo/condition.c
index f8bcc083bb0d..7e14f8fadbeb 100644
--- a/security/tomoyo/condition.c
+++ b/security/tomoyo/condition.c
@@ -714,25 +714,35 @@ void tomoyo_get_attributes(struct tomoyo_obj_info *obj)
 {
 	u8 i;
 	struct dentry *dentry = NULL;
+	struct vfsmount *mnt = NULL;
 
 	for (i = 0; i < TOMOYO_MAX_PATH_STAT; i++) {
 		struct inode *inode;
+		struct dentry *parent;
 
 		switch (i) {
 		case TOMOYO_PATH1:
 			dentry = obj->path1.dentry;
 			if (!dentry)
 				continue;
+			mnt = obj->path1.mnt;
 			break;
 		case TOMOYO_PATH2:
 			dentry = obj->path2.dentry;
 			if (!dentry)
 				continue;
+			mnt = obj->path2.mnt;
 			break;
 		default:
 			if (!dentry)
 				continue;
-			dentry = dget_parent(dentry);
+			parent = dget_parent(dentry);
+
+			/* Ensure that parent dentry is reachable. */
+			if (mnt->mnt_root != dentry->d_sb->s_root &&
+			    !is_subdir(dentry, mnt->mnt_root))
+				continue;
+			dentry = parent;
 			break;
 		}
 		inode = d_backing_inode(dentry);

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.34.1

