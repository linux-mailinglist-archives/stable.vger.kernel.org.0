Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2031C59DB59
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353226AbiHWKRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353186AbiHWKPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:15:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF297434D;
        Tue, 23 Aug 2022 02:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D066E6157F;
        Tue, 23 Aug 2022 09:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D11C433D7;
        Tue, 23 Aug 2022 09:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245210;
        bh=mZ1Eal+wbCJp/DyeVGMHEXpw1g7FqIdE0Oc7xwcTgtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6zbjlrINU8f7xEk0uYga8BFjdpCkL0XiauAhHUuaxphEWSQHN4qIQ01TUQ3TNbpW
         qxqN3Pd1GCupqJs/ja2f2/hVr+gJQ4/pCWet/te9JxeZXwzi4oPsZiyCk0JHIE10oN
         NfY30RUBIt23/lJ7RiOsLeVrRanphrgwoPdjQoL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alois Wohlschlager <alois1@gmx-topmail.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/244] ovl: warn if trusted xattr creation fails
Date:   Tue, 23 Aug 2022 10:26:21 +0200
Message-Id: <20220823080106.954894142@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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



