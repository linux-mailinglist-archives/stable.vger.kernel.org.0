Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9A344466
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhCVM7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231561AbhCVMvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F3961A01;
        Mon, 22 Mar 2021 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417167;
        bh=J+YpLjrfFR9D/MzxAuG51HJ0xmdU/gTqnZY1p9sGWx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2J1h/b7AoCzGOquwSr6AFySBmWRHQuzKwDOTAKblCMBvwE0cUQF/5/UYMyHsTEx0L
         xovr91CrssUG6NtiTDXNA0RdOrmuRUGnH3ZaVwoZ/YGSzSqPQrIdwQ3FfNTWLq0rJv
         3zFus6T4y9Kzx2Twy0NYbVqK7jWrnazzff8tKhJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.4 01/14] ext4: handle error of ext4_setup_system_zone() on remount
Date:   Mon, 22 Mar 2021 13:28:55 +0100
Message-Id: <20210322121919.250604804@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.202392464@linuxfoundation.org>
References: <20210322121919.202392464@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit d176b1f62f242ab259ff665a26fbac69db1aecba upstream.

ext4_setup_system_zone() can fail. Handle the failure in ext4_remount().

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200728130437.7804-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4968,7 +4968,10 @@ static int ext4_remount(struct super_blo
 		ext4_register_li_request(sb, first_not_zeroed);
 	}
 
-	ext4_setup_system_zone(sb);
+	err = ext4_setup_system_zone(sb);
+	if (err)
+		goto restore_opts;
+
 	if (sbi->s_journal == NULL && !(old_sb_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 


