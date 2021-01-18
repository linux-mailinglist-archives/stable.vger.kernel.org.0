Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAAB2FA9F2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393858AbhARTQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390486AbhARLip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1277E22B40;
        Mon, 18 Jan 2021 11:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969882;
        bh=3T7prH1bnmWp+rU07zvf1DE6UX7i7Rgrk+wwtgQ42Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuRvnputxbmRoe+VoUkMhBRiUhOpNspSr1I8+r0+PRY3esZsqHzObMnkHOg4AO9I6
         BXiitThsiIc7jqr5cuC6fJWg34h2b9ZLlzx6KsbU5ZrjMF41PVaBAb/17oT14ODIHS
         aXiTldzgOxF+x5Vafv6Jb9W4NMyVoI9gC2EjyjW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/76] ext4: dont leak old mountpoint samples
Date:   Mon, 18 Jan 2021 12:34:21 +0100
Message-Id: <20210118113342.003221910@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 5a3b590d4b2db187faa6f06adc9a53d6199fb1f9 ]

When the first file is opened, ext4 samples the mountpoint of the
filesystem in 64 bytes of the super block.  It does so using
strlcpy(), this means that the remaining bytes in the super block
string buffer are untouched.  If the mount point before had a longer
path than the current one, it can be reconstructed.

Consider the case where the fs was mounted to "/media/johnjdeveloper"
and later to "/".  The super block buffer then contains
"/\x00edia/johnjdeveloper".

This case was seen in the wild and caused confusion how the name
of a developer ands up on the super block of a filesystem used
in production...

Fix this by using strncpy() instead of strlcpy().  The superblock
field is defined to be a fixed-size char array, and it is already
marked using __nonstring in fs/ext4/ext4.h.  The consumer of the field
in e2fsprogs already assumes that in the case of a 64+ byte mount
path, that s_last_mounted will not be NUL terminated.

Link: https://lore.kernel.org/r/X9ujIOJG/HqMr88R@mit.edu
Reported-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index fd7ce3573a00a..1513e90fb6d2f 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -432,7 +432,7 @@ static int ext4_sample_last_mounted(struct super_block *sb,
 	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
 	if (err)
 		goto out_journal;
-	strlcpy(sbi->s_es->s_last_mounted, cp,
+	strncpy(sbi->s_es->s_last_mounted, cp,
 		sizeof(sbi->s_es->s_last_mounted));
 	ext4_handle_dirty_super(handle, sb);
 out_journal:
-- 
2.27.0



