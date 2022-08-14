Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1813D5924B0
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242367AbiHNQeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242515AbiHNQcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:32:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA2727148;
        Sun, 14 Aug 2022 09:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2A75B80B79;
        Sun, 14 Aug 2022 16:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDAAC433D7;
        Sun, 14 Aug 2022 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494426;
        bh=mZ1Eal+wbCJp/DyeVGMHEXpw1g7FqIdE0Oc7xwcTgtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iv/K7lDnkwUzyYkIzgb5bfKdHFKIj+Fj/2Baz3L/Qox/GgaecsCzAhtSf5ng4Vs3X
         baPBCPrzdOOguStSivAX8z4T/ZjqGpN6t41LdqvTbbGjbvAJK5KKblZAfVRUfY72Rp
         MktNMbyWM2v53I5dScNZ4OQVDCI/RaqM1zqUn4ryo+rri+xbplSdfD1ERmx9tB4LBR
         QmYHLlprJ/RmC8G9ArVkoYmkpWYeW2nCboQf0g5yiPmVdCRvGsCewdbvRLAKaK0BLD
         ZC09cJIdXJbkTwVRcdb7RpcnTod90Y0bBDLWABmFhj74J0FhSFk8hxev2q/pw8yXQq
         SvJ2CPQqA0EfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Alois Wohlschlager <alois1@gmx-topmail.de>,
        Sasha Levin <sashal@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/28] ovl: warn if trusted xattr creation fails
Date:   Sun, 14 Aug 2022 12:25:57 -0400
Message-Id: <20220814162610.2397644-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162610.2397644-1-sashal@kernel.org>
References: <20220814162610.2397644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit b10b85fe5149ee8b39fbbf86095b303632dde2cd ]

When mounting overlayfs in an unprivileged user namespace, trusted xattr
creation will fail.  This will lead to failures in some file operations,
e.g. in the following situation:

  mkdir lower upper work merged
  mkdir lower/directory
  mount -toverlay -olowerdir=lower,upperdir=upper,workdir=work none merged
  rmdir merged/directory
  mkdir merged/directory

The last mkdir will fail:

  mkdir: cannot create directory 'merged/directory': Input/output error

The cause for these failures is currently extremely non-obvious and hard to
debug.  Hence, warn the user and suggest using the userxattr mount option,
if it is not already supplied and xattr creation fails during the
self-check.

Reported-by: Alois Wohlschlager <alois1@gmx-topmail.de>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7bb0a47cb615..9837aaf9caf1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1413,11 +1413,12 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 */
 	err = ovl_do_setxattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE, "0", 1);
 	if (err) {
+		pr_warn("failed to set xattr on upper\n");
 		ofs->noxattr = true;
 		if (ofs->config.index || ofs->config.metacopy) {
 			ofs->config.index = false;
 			ofs->config.metacopy = false;
-			pr_warn("upper fs does not support xattr, falling back to index=off,metacopy=off.\n");
+			pr_warn("...falling back to index=off,metacopy=off.\n");
 		}
 		/*
 		 * xattr support is required for persistent st_ino.
@@ -1425,8 +1426,10 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		 */
 		if (ofs->config.xino == OVL_XINO_AUTO) {
 			ofs->config.xino = OVL_XINO_OFF;
-			pr_warn("upper fs does not support xattr, falling back to xino=off.\n");
+			pr_warn("...falling back to xino=off.\n");
 		}
+		if (err == -EPERM && !ofs->config.userxattr)
+			pr_info("try mounting with 'userxattr' option\n");
 		err = 0;
 	} else {
 		ovl_do_removexattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE);
-- 
2.35.1

