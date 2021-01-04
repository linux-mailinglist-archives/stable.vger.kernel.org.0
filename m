Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0558B2E9AA3
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbhADQAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbhADQAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAFD4224D2;
        Mon,  4 Jan 2021 15:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775968;
        bh=IoUTC2FqG8W9J9G5cgeLZDO+KDQz0TDFTuK2GSLsKqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkO5yBGO6N+rVERFI5oExpWibcpz72mY8pYLxS0LMikcpGPxu8jopGKGvKONu5GEO
         4Sem9T7Rse7iJGE0XK9f4EcpPwtr1w7GnTfutAzh25jOa2GcoSq3mriFmsEvCOO8sY
         /2n63tVVr8KIUnN/lQ29k0aZxqWVSSYxHlEx/FIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger@dilger.ca>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/47] ext4: dont remount read-only with errors=continue on reboot
Date:   Mon,  4 Jan 2021 16:57:10 +0100
Message-Id: <20210104155706.299546196@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit b08070eca9e247f60ab39d79b2c25d274750441f ]

ext4_handle_error() with errors=continue mount option can accidentally
remount the filesystem read-only when the system is rebooting. Fix that.

Fixes: 1dc1097ff60e ("ext4: avoid panic during forced reboot")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20201127113405.26867-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 920658ca8777d..06568467b0c27 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -455,19 +455,17 @@ static bool system_going_down(void)
 
 static void ext4_handle_error(struct super_block *sb)
 {
+	journal_t *journal = EXT4_SB(sb)->s_journal;
+
 	if (test_opt(sb, WARN_ON_ERROR))
 		WARN_ON_ONCE(1);
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || test_opt(sb, ERRORS_CONT))
 		return;
 
-	if (!test_opt(sb, ERRORS_CONT)) {
-		journal_t *journal = EXT4_SB(sb)->s_journal;
-
-		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
-		if (journal)
-			jbd2_journal_abort(journal, -EIO);
-	}
+	EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
+	if (journal)
+		jbd2_journal_abort(journal, -EIO);
 	/*
 	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
 	 * could panic during 'reboot -f' as the underlying device got already
-- 
2.27.0



