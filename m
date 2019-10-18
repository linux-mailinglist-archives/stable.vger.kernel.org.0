Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E2EDD1DF
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbfJRWGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbfJRWGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A43222D1;
        Fri, 18 Oct 2019 22:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436392;
        bh=uub7qoWJO07kCGY9mnSTpLi4SKi0+yvY+LER2AED5r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDru+jKmDHlhxvHqibX3EYEpp/csaQO3PhjuBD0TqZuTGSAImXFM5QjX4HaOsAqtz
         h9GgFSFTR3G+2+wMiWrNLLiohdMLYEUbSQbNnUnPk+aJUV0iR0i+/52564Wj7iQdaX
         Jxi5PMt6XpVeQdtxkOCc4OzSoKF5V0s5EukfgSi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 044/100] ext4: disallow files with EXT4_JOURNAL_DATA_FL from EXT4_IOC_SWAP_BOOT
Date:   Fri, 18 Oct 2019 18:04:29 -0400
Message-Id: <20191018220525.9042-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 6e589291f4b1b700ca12baec5930592a0d51e63c ]

A malicious/clueless root user can use EXT4_IOC_SWAP_BOOT to force a
corner casew which can lead to the file system getting corrupted.
There's no usefulness to allowing this, so just prohibit this case.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index abb6fcff0a1d3..783c54bb2ce75 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -132,6 +132,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
 	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
+	    (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL) ||
 	    ext4_has_inline_data(inode)) {
 		err = -EINVAL;
 		goto journal_err_out;
-- 
2.20.1

