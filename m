Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F972E3F9F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502309AbgL1O1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502308AbgL1O1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A752222AEC;
        Mon, 28 Dec 2020 14:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165611;
        bh=9AZ72TUaEtN1g9J+gej0QigPOa+ue3PhmJuS5YWN/vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Su/OYkt0J2Q43hTalk48wxxN7MaxDgAFhjXWYpIV+fBux8kXdOKSVvImNQyCI/CDz
         Z+1ujltsFxjG6n5Ly1XTT7pnAQ1CY4eU7CtwIvz49v+ztsjpBFI8NdyVuSnM4L4mWS
         DdXvWFAGv8vQw3rG2FZwUmTd0sR7q/daQE1FtBns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger@dilger.ca>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 593/717] ext4: dont remount read-only with errors=continue on reboot
Date:   Mon, 28 Dec 2020 13:49:51 +0100
Message-Id: <20201228125049.321922927@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit b08070eca9e247f60ab39d79b2c25d274750441f upstream.

ext4_handle_error() with errors=continue mount option can accidentally
remount the filesystem read-only when the system is rebooting. Fix that.

Fixes: 1dc1097ff60e ("ext4: avoid panic during forced reboot")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20201127113405.26867-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -666,19 +666,17 @@ static bool system_going_down(void)
 
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
-		ext4_set_mount_flag(sb, EXT4_MF_FS_ABORTED);
-		if (journal)
-			jbd2_journal_abort(journal, -EIO);
-	}
+	ext4_set_mount_flag(sb, EXT4_MF_FS_ABORTED);
+	if (journal)
+		jbd2_journal_abort(journal, -EIO);
 	/*
 	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
 	 * could panic during 'reboot -f' as the underlying device got already


