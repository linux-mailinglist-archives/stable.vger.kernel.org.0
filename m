Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572CE2A5909
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgKCUnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbgKCUnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0B7C223BF;
        Tue,  3 Nov 2020 20:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436219;
        bh=doA8cbooLMM+qyK1FkxLDqNfk/it7BcN3ktOBSfQfdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJoAk74CgfEUzGd0bwsMD1U3LqY4cmBmys0hFtIEZ0GqIhtNW3Ad57eNDgUClX8Gi
         JWtI03na1x12am+BHQOYPUHjTpn1r4ZR+11N0AC6sUF02G3eziDO2xA7msrMBfBr82
         v2oV4BY/G/AbotWT32lYOf4Cgbb5gXjDQ/p0UOV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 155/391] ext4: Detect already used quota file early
Date:   Tue,  3 Nov 2020 21:33:26 +0100
Message-Id: <20201103203357.292350688@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ea425b49b3456..d31ae5a878594 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6042,6 +6042,11 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
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
2.27.0



