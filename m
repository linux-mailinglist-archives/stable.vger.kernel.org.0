Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7922ABD9F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgKINrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729878AbgKIM4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ECD4207BC;
        Mon,  9 Nov 2020 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926607;
        bh=EB4a0dG3qGVOfgBtF/OpJq7h7J3wPGuUxpGE74WC7/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsprAhk47uy22Jg1llheRJjDXezKd0DdcsZorLfY713cWPs2iBJLCbf6LBeDVFjSI
         TqvDaNwt8ftTAQAdEBtN0EO2YlMTmkajPyvHjGND0mmQpPqODeX6XjYB2MsSYiDMJo
         mP4JQB65Hu5Tw1dqqNffqOmSBKbjn00Y4/OfeYUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 28/86] ext4: Detect already used quota file early
Date:   Mon,  9 Nov 2020 13:54:35 +0100
Message-Id: <20201109125022.207985207@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
index aca086a25b2ef..6350971852e19 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5185,6 +5185,11 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
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



