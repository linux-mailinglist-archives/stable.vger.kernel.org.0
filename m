Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40199291B75
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbgJRTbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732043AbgJRT1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A15BC22267;
        Sun, 18 Oct 2020 19:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049242;
        bh=qQkpsY95igRkNtXkV+01ckVVt9mzZ3IvlB7j+mGHTu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+5W3zNrCj6KjYHqoD4RK3hbR3ZgeyqzqWcbOLl0StucvY12AMTWWoe5l7SmYjryK
         ePYSVGzSazqvOjkGOGHNhwmm1MogM/9yG+Fhx+lWXv7leXstWIu9L24+upM7mfaruf
         t2JbxeRAIIYzIaiZiPbMeUjiV0thnjm8jM8WQQYg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+c9e294bbe0333a6b7640@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 38/41] reiserfs: Fix memory leak in reiserfs_parse_options()
Date:   Sun, 18 Oct 2020 15:26:32 -0400
Message-Id: <20201018192635.4056198-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192635.4056198-1-sashal@kernel.org>
References: <20201018192635.4056198-1-sashal@kernel.org>
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
index 677608a89b08d..c533d8715a6ca 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1234,6 +1234,10 @@ static int reiserfs_parse_options(struct super_block *s,
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
@@ -1263,10 +1267,6 @@ static int reiserfs_parse_options(struct super_block *s,
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

