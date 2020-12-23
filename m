Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA27D2E17A6
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgLWCRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgLWCRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5D822256F;
        Wed, 23 Dec 2020 02:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689797;
        bh=x5PIUwxH5WbhePd4i2PbNKAofydYlihwur288ZNn9Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5AHmza8EQqndwxYNZCrksCyz1I8FL1aftAt4yR0j4JQPA8b4GweWKDDuXQ0UvvCw
         dbSi/KLPduvooc6yl7JeRGNB/BwIjjM65G3riayW42QmR6jKrVqs3ZK76zuhBpC9v1
         1VGM0scFD7svDYNHgAtnw/FFaHdEnOAkfctwgwDJ1n3lXJVp5kblvuTWJClr1LC36Q
         eGsQ6k8eM6I5BnANG0XOUmfKWSRDykvBCq+JmI+2n17+gA3TDDCWAPv7InAABghn1B
         Gpg/qsaPjYrlOJCxUJfc5NXJJEI8y9W6ruOgs9TPWZMOdPkgRMsJ/WLTd/OhG15cGL
         h0rGJXsmZzp1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 008/217] tomoyo: fix clang pointer arithmetic warning
Date:   Tue, 22 Dec 2020 21:12:57 -0500
Message-Id: <20201223021626.2790791-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d9594e0409651a237903a13c9718df889f43d43b ]

clang warns about additions on NULL pointers being undefined in C:

security/tomoyo/securityfs_if.c:226:59: warning: arithmetic on a null pointer treated as a cast from integer to pointer is a GNU extension [-Wnull-pointer-arithmetic]
        securityfs_create_file(name, mode, parent, ((u8 *) NULL) + key,

Change the code to instead use a cast through uintptr_t to avoid
the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/securityfs_if.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/tomoyo/securityfs_if.c b/security/tomoyo/securityfs_if.c
index 546281c5b233a..065f4941c4d8c 100644
--- a/security/tomoyo/securityfs_if.c
+++ b/security/tomoyo/securityfs_if.c
@@ -131,8 +131,8 @@ static const struct file_operations tomoyo_self_operations = {
  */
 static int tomoyo_open(struct inode *inode, struct file *file)
 {
-	const int key = ((u8 *) file_inode(file)->i_private)
-		- ((u8 *) NULL);
+	const u8 key = (uintptr_t) file_inode(file)->i_private;
+
 	return tomoyo_open_control(key, file);
 }
 
@@ -223,7 +223,7 @@ static const struct file_operations tomoyo_operations = {
 static void __init tomoyo_create_entry(const char *name, const umode_t mode,
 				       struct dentry *parent, const u8 key)
 {
-	securityfs_create_file(name, mode, parent, ((u8 *) NULL) + key,
+	securityfs_create_file(name, mode, parent, (void *) (uintptr_t) key,
 			       &tomoyo_operations);
 }
 
-- 
2.27.0

