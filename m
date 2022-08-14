Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB5A5923D2
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbiHNQZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241471AbiHNQYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB3015A17;
        Sun, 14 Aug 2022 09:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A4B4B80B7C;
        Sun, 14 Aug 2022 16:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E33C4314E;
        Sun, 14 Aug 2022 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494152;
        bh=nn64llpKQwSVbNBIKVAhqVnQyKZuwOGj7VhDj+fGt14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZDfoAZvkwuXt1X36A2QFVfPNd/AN/x3xD4xFxONQEY2n2NyFQmGu2feKSAsnJJYJ
         Fwta6wcEjb8Myi6wU08twTcGo2PvX1AA0AEOk8g5vphY+lFq12U72Yhk0igAdN5AgE
         HzKjksO2goz7qQYvbhATzdlcD5IEYOjR5qlq8b/JDV2VWIVimngfGp9kk+eC+VbyWl
         adcLrnPmgEpcXz5RN8VGPJe3bXD/NakImS3oX5jB4mcgrGElX0MjWhUO0E+mSILuNR
         9gMqfImLQTA53LAttW8rmZfB0OXu/b2eteL2W0GYU6CCq4cZjoRGV1IwilXvMvt1jS
         So3iKN1akW+5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Alois Wohlschlager <alois1@gmx-topmail.de>,
        Sasha Levin <sashal@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 34/48] ovl: warn if trusted xattr creation fails
Date:   Sun, 14 Aug 2022 12:19:27 -0400
Message-Id: <20220814161943.2394452-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
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
index 1ce5c9698393..4c2096130209 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1418,11 +1418,12 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 */
 	err = ovl_setxattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE, "0", 1);
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
@@ -1430,8 +1431,10 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
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
 		ovl_removexattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE);
-- 
2.35.1

