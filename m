Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177431A9EBB
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409363AbgDOLrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897638AbgDOLrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D097C214D8;
        Wed, 15 Apr 2020 11:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951244;
        bh=lNNqbJWeyj+NqDkQDPuD5oVoQlCpwzDAEpq7zx6bMOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xm4RlvQBDcQtnuJnOSgW6CFkgQE3VHOR8O0RWNrFbHXX0ZSLxtPNPhNxWDQf5Vrfi
         0+33FrGVGj7YpF3PSaIsGNG+moUbd/GOB2i8AoI/F7LiPObTNS2l6TA1OSr6iDRvRh
         GQ/sEvI2rervPStEidW5Q+YjThTk495L3C7WeJJY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/30] ext4: do not commit super on read-only bdev
Date:   Wed, 15 Apr 2020 07:46:52 -0400
Message-Id: <20200415114711.15381-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114711.15381-1-sashal@kernel.org>
References: <20200415114711.15381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit c96e2b8564adfb8ac14469ebc51ddc1bfecb3ae2 ]

Under some circumstances we may encounter a filesystem error on a
read-only block device, and if we try to save the error info to the
superblock and commit it, we'll wind up with a noisy error and
backtrace, i.e.:

[ 3337.146838] EXT4-fs error (device pmem1p2): ext4_get_journal_inode:4634: comm mount: inode #0: comm mount: iget: illegal inode #
------------[ cut here ]------------
generic_make_request: Trying to write to read-only block-device pmem1p2 (partno 2)
WARNING: CPU: 107 PID: 115347 at block/blk-core.c:788 generic_make_request_checks+0x6b4/0x7d0
...

To avoid this, commit the error info in the superblock only if the
block device is writable.

Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/4b6e774d-cc00-3469-7abb-108eb151071a@sandeen.net
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f5646bcad7702..af55757bad699 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -369,7 +369,8 @@ static void save_error_info(struct super_block *sb, const char *func,
 			    unsigned int line)
 {
 	__save_error_info(sb, func, line);
-	ext4_commit_super(sb, 1);
+	if (!bdev_read_only(sb->s_bdev))
+		ext4_commit_super(sb, 1);
 }
 
 /*
-- 
2.20.1

