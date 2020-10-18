Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF7291BDC
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbgJRTeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731688AbgJRT01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875E720791;
        Sun, 18 Oct 2020 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049187;
        bh=Aa89ekcP0bkHteM/86ph1fGH+lQDJMLPv5zVTXiphj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T09PiAMZLrwJaYdWejsfTHX0SLXXVZ8UNebQZSu0r1/JrwbsscjYhJlW7hXyUZHat
         UT/N6BV7ip0slKPT2xn4veCqYpT+vD6//f4c5M4MAlgqM/PFI8ePxkLaA4UdEI/Rst
         i3v9vaqf8h7VZcoLn92wposAaONTeFVHbtWgJG6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+c9e294bbe0333a6b7640@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 47/52] reiserfs: Fix memory leak in reiserfs_parse_options()
Date:   Sun, 18 Oct 2020 15:25:24 -0400
Message-Id: <20201018192530.4055730-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit e9d4709fcc26353df12070566970f080e651f0c9 ]

When a usrjquota or grpjquota mount option is used multiple times, we
will leak memory allocated for the file name. Make sure the last setting
is used and all the previous ones are properly freed.

Reported-by: syzbot+c9e294bbe0333a6b7640@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 9caf3948417c0..fbae5f4eea09c 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1264,6 +1264,10 @@ static int reiserfs_parse_options(struct super_block *s,
 						 "turned on.");
 				return 0;
 			}
+			if (qf_names[qtype] !=
+			    REISERFS_SB(s)->s_qf_names[qtype])
+				kfree(qf_names[qtype]);
+			qf_names[qtype] = NULL;
 			if (*arg) {	/* Some filename specified? */
 				if (REISERFS_SB(s)->s_qf_names[qtype]
 				    && strcmp(REISERFS_SB(s)->s_qf_names[qtype],
@@ -1293,10 +1297,6 @@ static int reiserfs_parse_options(struct super_block *s,
 				else
 					*mount_options |= 1 << REISERFS_GRPQUOTA;
 			} else {
-				if (qf_names[qtype] !=
-				    REISERFS_SB(s)->s_qf_names[qtype])
-					kfree(qf_names[qtype]);
-				qf_names[qtype] = NULL;
 				if (qtype == USRQUOTA)
 					*mount_options &= ~(1 << REISERFS_USRQUOTA);
 				else
-- 
2.25.1

