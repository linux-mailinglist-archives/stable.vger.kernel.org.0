Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D17C299EA9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440682AbgJ0AQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411534AbgJ0AKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B71E2087C;
        Tue, 27 Oct 2020 00:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757431;
        bh=D6HTFfDrOcFlIEIdxFRblmsSQYl9Cvw0/G7reCTd+cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5vRl02qodEbejuBymGMeJQ2wZjVw93Dom3ceVzb+sMWaIxz1s7WsCT4pUSAd3N46
         lWy7Gr9NpZa7Iq4P6ITux1eIK0D/HwdsczDlksEP8LZCpxyCStjVIVgr065uFzMTHJ
         LnBPuLOqWv6Qxt0RM+7v9VgSVJwSGYwWaLHxvKk0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 37/46] ext4: Detect already used quota file early
Date:   Mon, 26 Oct 2020 20:09:36 -0400
Message-Id: <20201027000946.1026923-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit e0770e91424f694b461141cbc99adf6b23006b60 ]

When we try to use file already used as a quota file again (for the same
or different quota type), strange things can happen. At the very least
lockdep annotations may be wrong but also inode flags may be wrongly set
/ reset. When the file is used for two quota types at once we can even
corrupt the file and likely crash the kernel. Catch all these cases by
checking whether passed file is already used as quota file and bail
early in that case.

This fixes occasional generic/219 failure due to lockdep complaint.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20201015110330.28716-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 634c822d1dc98..d941b0cee5f8e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5626,6 +5626,11 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	/* Quotafile not on the same filesystem? */
 	if (path->dentry->d_sb != sb)
 		return -EXDEV;
+
+	/* Quota already enabled for this file? */
+	if (IS_NOQUOTA(d_inode(path->dentry)))
+		return -EBUSY;
+
 	/* Journaling quota? */
 	if (EXT4_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not in fs root? */
-- 
2.25.1

