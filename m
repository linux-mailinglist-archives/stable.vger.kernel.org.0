Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F9F25935E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgIAPZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbgIAPZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:25:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F5D2137B;
        Tue,  1 Sep 2020 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973899;
        bh=0sF2i8X150aJR9s1ThR83KFzBqql1OUgtwul40T7+EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ognpi+EeNs8KjRP/TGPamf7rJOoFyWckovLL+qU2C59p79jkO1bb0bLnSpvp63sgp
         R8TW+nDzrKvJHEdlOG16rzfQXqp64AT0hyvUwkSOh2l8ocydy/7lPIDvptDUPo1V65
         RCp/GhN2DAHmQM0uRicxBCSQ19KoY20hLLYnS3ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/125] ext4: handle error of ext4_setup_system_zone() on remount
Date:   Tue,  1 Sep 2020 17:10:19 +0200
Message-Id: <20200901150937.714785240@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
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
index 03ebb0b385467..daabd7a2cee81 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5470,7 +5470,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
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



