Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E92229B5DD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796277AbgJ0PRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796198AbgJ0PQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:16:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E060520657;
        Tue, 27 Oct 2020 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811767;
        bh=TfWJq0F+eNJwR3zuDSJhyRJNiFATVZ7YZaKoLVaSsv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ayi4w9qYZsRda/8FCF8NJzRamHXvuO8JS6CVKHjYwrtRN6mQWboTmZ6JfscUPHYh
         yzgAVEefJHwzVDKq76gFymFWWGndPpLg+YAdv3tOOlGYuM3sVryqcHnuPS/LRSLVJ4
         zpA3UEVV5YdMcF51RiRDJ9w7gWzc8LPeim2bKJ1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c9e294bbe0333a6b7640@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 609/633] reiserfs: Fix memory leak in reiserfs_parse_options()
Date:   Tue, 27 Oct 2020 14:55:52 +0100
Message-Id: <20201027135551.389626216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a6bce5b1fb1dc..1b9c7a387dc71 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1258,6 +1258,10 @@ static int reiserfs_parse_options(struct super_block *s,
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
@@ -1287,10 +1291,6 @@ static int reiserfs_parse_options(struct super_block *s,
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



