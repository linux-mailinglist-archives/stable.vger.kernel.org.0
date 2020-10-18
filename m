Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06518291DD7
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgJRTV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbgJRTVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE46A222B9;
        Sun, 18 Oct 2020 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048885;
        bh=B3653fjgyO04/ZEw1TGbebY8FOiIxsaRaeXQ3L/z2ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gs+nmhCf9oWWjFxT7WJ9XcYbfSXXcokrwLqqF34EhlQVmwmrSuoFDLHmiB29rrrxT
         4phtnSxC719d+pzX9a6Ze5RVOf6zXmSQhj+n7SD8z/6hwPBSHTwC167N5+1RphZ8Y4
         G7QTgOb73le/PKVW7nf4ST10EfM6zeFYMBwWgaiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+9991561e714f597095da@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 048/101] udf: Limit sparing table size
Date:   Sun, 18 Oct 2020 15:19:33 -0400
Message-Id: <20201018192026.4053674-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 44ac6b829c4e173fdf6df18e6dd86aecf9a3dc99 ]

Although UDF standard allows it, we don't support sparing table larger
than a single block. Check it during mount so that we don't try to
access memory beyond end of buffer.

Reported-by: syzbot+9991561e714f597095da@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index f747bf72edbe0..a6ce0ddb392c7 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1353,6 +1353,12 @@ static int udf_load_sparable_map(struct super_block *sb,
 			(int)spm->numSparingTables);
 		return -EIO;
 	}
+	if (le32_to_cpu(spm->sizeSparingTable) > sb->s_blocksize) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Too big sparing table size (%u)\n",
+			le32_to_cpu(spm->sizeSparingTable));
+		return -EIO;
+	}
 
 	for (i = 0; i < spm->numSparingTables; i++) {
 		loc = le32_to_cpu(spm->locSparingTable[i]);
-- 
2.25.1

