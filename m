Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EA764FA65
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiLQPeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiLQPdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:33:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D0A15A2A;
        Sat, 17 Dec 2022 07:29:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7064F60C12;
        Sat, 17 Dec 2022 15:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1A6C433F0;
        Sat, 17 Dec 2022 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290949;
        bh=OOTfHPq132Z/gNUYFksJS8kJvhXbse9O8ds3QhYEmVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uclB2APf0sgqkO7Avml0FDcKj6RA4nHl8+aoWyP4aox1jzDBYmbZtydlZF0q/ShAb
         pwkDdQ0U9Eata0pqvfAsvHsQd9TdlRiISd2LyuUjEk4Db/LGib8ao5dwf4zg0y9TEW
         3TCHVErTBypZjhPKyw/FZVTUyW1jfPY912/jQaZNH/oG2v+Tx/MG2CMZxyPKBim3H/
         FaO5MWj30DpTvjFqSs9sdYz2AmRxfe8kJ6S+VFwuAHPA5LFZETbsBWRJtKML0uywbe
         d/7u183lrXUTEvowZoB9qF0XN4YjKyAPT8V1yO8YE5HZDe2cKHu+LnKi42cXb0UxRv
         XM3MCNHRTfPeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Dr. David Alan Gilbert" <linux@treblig.org>,
        syzbot+5fc38b2ddbbca7f5c680@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>, shaggy@kernel.org,
        brauner@kernel.org, jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.15 03/10] jfs: Fix fortify moan in symlink
Date:   Sat, 17 Dec 2022 10:28:53 -0500
Message-Id: <20221217152902.98870-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152902.98870-1-sashal@kernel.org>
References: <20221217152902.98870-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Dr. David Alan Gilbert" <linux@treblig.org>

[ Upstream commit ebe060369f8d6e4588b115f252bebf5ba4d64350 ]

JFS has in jfs_incore.h:

      /* _inline may overflow into _inline_ea when needed */
      /* _inline_ea may overlay the last part of
       * file._xtroot if maxentry = XTROOTINITSLOT
       */
      union {
        struct {
          /* 128: inline symlink */
          unchar _inline[128];
          /* 128: inline extended attr */
          unchar _inline_ea[128];
        };
        unchar _inline_all[256];

and currently the symlink code copies into _inline;
if this is larger than 128 bytes it triggers a fortify warning of the
form:

  memcpy: detected field-spanning write (size 132) of single field
     "ip->i_link" at fs/jfs/namei.c:950 (size 18446744073709551615)

when it's actually OK.

Copy it into _inline_all instead.

Reported-by: syzbot+5fc38b2ddbbca7f5c680@syzkaller.appspotmail.com
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 9db4f5789c0e..4fbbf88435e6 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -946,7 +946,7 @@ static int jfs_symlink(struct user_namespace *mnt_userns, struct inode *dip,
 	if (ssize <= IDATASIZE) {
 		ip->i_op = &jfs_fast_symlink_inode_operations;
 
-		ip->i_link = JFS_IP(ip)->i_inline;
+		ip->i_link = JFS_IP(ip)->i_inline_all;
 		memcpy(ip->i_link, name, ssize);
 		ip->i_size = ssize - 1;
 
-- 
2.35.1

