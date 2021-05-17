Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF161382FD5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbhEQOVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239201AbhEQOTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3EF861436;
        Mon, 17 May 2021 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260651;
        bh=KdfDzzyoqBNGKNTmKypKQG7wiIFEWHT0CY+kW87B8fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBER9xt9PNmhqtZJ0f+WylD/6C01wjBh+NHTAlYVqOztIQDcgC66I4OgQEMkwssb7
         ScSdPtItmhL7iQQVSE4fSpUY7TwDXFs2GOz2fzKleSMGCmpo5cbXjvcG5iVRGSGGBu
         PvVyA5KlB9519Raupio76dNs20t8XuoZMT+/UPC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 143/363] f2fs: fix to restrict mount condition on readonly block device
Date:   Mon, 17 May 2021 16:00:09 +0200
Message-Id: <20210517140307.452923563@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 23738e74472f9c5f3a05a68724a2ccfba97d283d ]

When we mount an unclean f2fs image in a readonly block device, let's
make mount() succeed only when there is no recoverable data in that
image, otherwise after mount(), file fsyned won't be recovered as user
expected.

Fixes: 938a184265d7 ("f2fs: give a warning only for readonly partition")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1d010a3a144f..d852d96773a3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3929,10 +3929,18 @@ try_onemore:
 		 * previous checkpoint was not done by clean system shutdown.
 		 */
 		if (f2fs_hw_is_readonly(sbi)) {
-			if (!is_set_ckpt_flags(sbi, CP_UMOUNT_FLAG))
-				f2fs_err(sbi, "Need to recover fsync data, but write access unavailable");
-			else
-				f2fs_info(sbi, "write access unavailable, skipping recovery");
+			if (!is_set_ckpt_flags(sbi, CP_UMOUNT_FLAG)) {
+				err = f2fs_recover_fsync_data(sbi, true);
+				if (err > 0) {
+					err = -EROFS;
+					f2fs_err(sbi, "Need to recover fsync data, but "
+						"write access unavailable, please try "
+						"mount w/ disable_roll_forward or norecovery");
+				}
+				if (err < 0)
+					goto free_meta;
+			}
+			f2fs_info(sbi, "write access unavailable, skipping recovery");
 			goto reset_checkpoint;
 		}
 
-- 
2.30.2



