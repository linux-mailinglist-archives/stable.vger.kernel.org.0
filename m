Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AC8EEC93
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388021AbfKDV6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387589AbfKDV6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:31 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B68120650;
        Mon,  4 Nov 2019 21:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904710;
        bh=KhLp5dFr/z8ZsXzQbKR2uEHvcQB5nTWQwa601RrePeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQOIol9jUgdW7OslxNgpzQiN33h8pFJ+ZZ433IrHTq23/OC9EQ0s7BNpeO+ARRqD5
         HCfUImnGOftXkxij0yU20C0w92b9r5mR0s08cZloTCsGMdICrOirgDUCYE5htwqVEZ
         E6DTNPJmNuXHpTcyexdKQZBvhDtDTI4Xa/moynmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/149] f2fs: flush quota blocks after turnning it off
Date:   Mon,  4 Nov 2019 22:43:22 +0100
Message-Id: <20191104212130.837568625@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 0e0667b625cf64243df83171bff61f9d350b9ca5 ]

After quota_off, we'll get some dirty blocks. If put_super don't have a chance
to flush them by checkpoint, it causes NULL pointer exception in end_io after
iput(node_inode). (e.g., by checkpoint=disable)

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6851afc3bf805..d9106bbe7df63 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1886,6 +1886,12 @@ void f2fs_quota_off_umount(struct super_block *sb)
 			set_sbi_flag(F2FS_SB(sb), SBI_NEED_FSCK);
 		}
 	}
+	/*
+	 * In case of checkpoint=disable, we must flush quota blocks.
+	 * This can cause NULL exception for node_inode in end_io, since
+	 * put_super already dropped it.
+	 */
+	sync_filesystem(sb);
 }
 
 static void f2fs_truncate_quota_inode_pages(struct super_block *sb)
-- 
2.20.1



