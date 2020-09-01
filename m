Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1F32598D6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgIAQdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730707AbgIAPbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:31:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22B421548;
        Tue,  1 Sep 2020 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974291;
        bh=pDSFRSTQwnciu5Fe9o6G+gZ7lzOqtlB0ZrjDnXzhTZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkJgr8sGNJ0zwcByXvWMe8j0b9ID9V+1DAPT7/EvqKxiQc1ycIZn21a4Mv4ikXga9
         YfEPNFB8lhlkzfZu9m5+NHPrbXpSNNLs/O5Hb7U3JraHX0LdIYnvT2TyjY1FLtvHnT
         +B99hOgJAYGjoKPXE3ZCDZ5JIXzsAkoWK7l3+z4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/214] ext4: handle error of ext4_setup_system_zone() on remount
Date:   Tue,  1 Sep 2020 17:09:59 +0200
Message-Id: <20200901150958.689993418@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 92a6741c4bdd9..e8923013accc0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5563,7 +5563,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
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



