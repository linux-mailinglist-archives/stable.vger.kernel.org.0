Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64753CE2FA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhGSPdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347525AbhGSPTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3BC61414;
        Mon, 19 Jul 2021 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710298;
        bh=FL1PTp73Fvj1PbY80kEq4ykA3rIwBqcs8t7Gm9YEcew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjStnsa0h7WDDUwBS6Q2gU+c6UvvbhL/z/jqqpflEnzukL8tdCUFJjvgt2vJ00Esu
         ly8Vokxdf4rOLXOi95ydxIAV5R9a5PNJl4o82lqWP5Lsg3D0jh/Jm+/UL/axgaM6I2
         /fKZqXdFV7bmEs3n+TfQBxAAcvg87R0pR22GyB2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/243] ubifs: Fix off-by-one error
Date:   Mon, 19 Jul 2021 16:53:08 +0200
Message-Id: <20210719144946.037816548@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit d984bcf5766dbdbe95d325bb8a1b49a996fecfd4 ]

An inode is allowed to have ubifs_xattr_max_cnt() xattrs, so we must
complain only when an inode has more xattrs, having exactly
ubifs_xattr_max_cnt() xattrs is fine.
With this the maximum number of xattrs can be created without hitting
the "has too many xattrs" warning when removing it.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/journal.c | 2 +-
 fs/ubifs/xattr.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 091c2ad8f211..7927dea2baba 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -881,7 +881,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 		struct inode *xino;
 		struct ubifs_dent_node *xent, *pxent = NULL;
 
-		if (ui->xattr_cnt >= ubifs_xattr_max_cnt(c)) {
+		if (ui->xattr_cnt > ubifs_xattr_max_cnt(c)) {
 			ubifs_err(c, "Cannot delete inode, it has too much xattrs!");
 			goto out_release;
 		}
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 09280796fc61..17745f5462f0 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -512,7 +512,7 @@ int ubifs_purge_xattrs(struct inode *host)
 	struct fscrypt_name nm = {0};
 	int err;
 
-	if (ubifs_inode(host)->xattr_cnt < ubifs_xattr_max_cnt(c))
+	if (ubifs_inode(host)->xattr_cnt <= ubifs_xattr_max_cnt(c))
 		return 0;
 
 	ubifs_warn(c, "inode %lu has too many xattrs, doing a non-atomic deletion",
-- 
2.30.2



