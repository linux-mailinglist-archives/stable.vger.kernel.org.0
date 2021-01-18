Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EB12FA420
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405559AbhARPHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:07:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390786AbhARLmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA4922D5B;
        Mon, 18 Jan 2021 11:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970134;
        bh=JQg7ipeKXY5ei8zldoNHAjLBj6NEWWt77CDe5cnRE+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DKrj9rxBHiqgapFEOPNnEGS37kt0oFjCMH3D0mx17zl3tae+xbO9Nn9UwYnhL6Ve
         nYoYH6SjnJY+IMxb1M0tpUSE53WXFJOtcpg2xkmHwKXIUiHWfoKMAN+4+4p2IbeLYa
         sl6nwZFh/LOTwv+cKCbA1QAPBHnC+5rMrihQv1ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/152] ext4: dont leak old mountpoint samples
Date:   Mon, 18 Jan 2021 12:33:47 +0100
Message-Id: <20210118113355.287099265@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
index 3ed8c048fb12c..b692355b8c770 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -809,7 +809,7 @@ static int ext4_sample_last_mounted(struct super_block *sb,
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



