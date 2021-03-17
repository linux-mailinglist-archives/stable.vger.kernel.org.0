Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE2633F5CF
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhCQQoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:44:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:32930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232574AbhCQQoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 12:44:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4742EAE15;
        Wed, 17 Mar 2021 16:44:19 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E8D201E11DB; Wed, 17 Mar 2021 17:44:18 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH stable 4.14.y 1/3] ext4: handle error of ext4_setup_system_zone() on remount
Date:   Wed, 17 Mar 2021 17:44:12 +0100
Message-Id: <20210317164414.17364-2-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210317164414.17364-1-jack@suse.cz>
References: <20210317164414.17364-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d176b1f62f242ab259ff665a26fbac69db1aecba upstream.

ext4_setup_system_zone() can fail. Handle the failure in ext4_remount().

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200728130437.7804-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eaa8bcd59b6a..8e6178dc0e6e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5364,7 +5364,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		ext4_register_li_request(sb, first_not_zeroed);
 	}
 
-	ext4_setup_system_zone(sb);
+	err = ext4_setup_system_zone(sb);
+	if (err)
+		goto restore_opts;
+
 	if (sbi->s_journal == NULL && !(old_sb_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
-- 
2.26.2

