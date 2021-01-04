Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABBD2E9AC2
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbhADP73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbhADP73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FBC5224F4;
        Mon,  4 Jan 2021 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775902;
        bh=rJIdyn+V37VsNc15Ud6KcMHR9dHN03RWxAoL3TdeyFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiMWnNk8Kaf1fwnR4fNhWLHllGtZddj7tq5TH3KlRa6+4VCbctFKTfRc5CbxMFV1s
         EYuhIlTSn6JTyZWLIv04SGpMBhG82TxUou2lgJzYkFv5f5Mysb4QcCZnV3KkC7fRSt
         xRCnMoZ5ArUD3IbLZwP4FyQur6bGkVvXo5WTbwmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 04/35] f2fs: prevent creating duplicate encrypted filenames
Date:   Mon,  4 Jan 2021 16:57:07 +0100
Message-Id: <20210104155703.601307898@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit bfc2b7e8518999003a61f91c1deb5e88ed77b07d upstream.

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on f2fs by rejecting no-key dentries in f2fs_add_link().

Note that the weird check for the current task in f2fs_do_add_link()
seems to make this bug difficult to reproduce on f2fs.

Fixes: 9ea97163c6da ("f2fs crypto: add filename encryption for f2fs_add_link")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2857,6 +2857,8 @@ bool f2fs_empty_dir(struct inode *dir);
 
 static inline int f2fs_add_link(struct dentry *dentry, struct inode *inode)
 {
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
 	return f2fs_do_add_link(d_inode(dentry->d_parent), &dentry->d_name,
 				inode, inode->i_ino, inode->i_mode);
 }


