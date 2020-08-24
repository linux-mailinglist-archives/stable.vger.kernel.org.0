Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F1250650
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgHXRaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgHXQfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B05A121741;
        Mon, 24 Aug 2020 16:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286917;
        bh=6AVvTKUZefUGBfLQWA2niBSjSCOXjC6YCl26Eoyy9L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WocEslNqCSojv26hBaozXlqz4bL4txM2q+rP1+K/2IQq18IJz0dkU+yTTmoTcLYMK
         wAdrx4BZ8y1lYb6XAfNN1n/hRAlfhJm01SNv3NPT6+oLqYYlgC8/Ec7ZDu0EFp0xUq
         HvPiuG2KqoClbgTfWAZxDbPyITJbKsG4+p3MRxrA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 10/63] ext4: handle error of ext4_setup_system_zone() on remount
Date:   Mon, 24 Aug 2020 12:34:10 -0400
Message-Id: <20200824163504.605538-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit d176b1f62f242ab259ff665a26fbac69db1aecba ]

ext4_setup_system_zone() can fail. Handle the failure in ext4_remount().

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200728130437.7804-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 85849e5b31b28..54d1c09329e55 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5716,7 +5716,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		ext4_register_li_request(sb, first_not_zeroed);
 	}
 
-	ext4_setup_system_zone(sb);
+	err = ext4_setup_system_zone(sb);
+	if (err)
+		goto restore_opts;
+
 	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
 		err = ext4_commit_super(sb, 1);
 		if (err)
-- 
2.25.1

