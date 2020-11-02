Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642352A317E
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 18:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgKBR1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 12:27:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:49882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727288AbgKBR1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 12:27:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0F4CEB2CB;
        Mon,  2 Nov 2020 17:27:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 822B11E1303; Mon,  2 Nov 2020 18:27:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 2/2] quota: Sanity-check quota file headers on load
Date:   Mon,  2 Nov 2020 18:27:33 +0100
Message-Id: <20201102172733.23444-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201102172733.23444-1-jack@suse.cz>
References: <20201102172733.23444-1-jack@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Perform basic sanity checks of quota headers to avoid kernel crashes on
corrupted quota files.

CC: stable@vger.kernel.org
Reported-by: syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota_v2.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index e69a2bfdd81c..c21106557a37 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -157,6 +157,25 @@ static int v2_read_file_info(struct super_block *sb, int type)
 		qinfo->dqi_entry_size = sizeof(struct v2r1_disk_dqblk);
 		qinfo->dqi_ops = &v2r1_qtree_ops;
 	}
+	ret = -EUCLEAN;
+	/* Some sanity checks of the read headers... */
+	if ((loff_t)qinfo->dqi_blocks << qinfo->dqi_blocksize_bits >
+	    i_size_read(sb_dqopt(sb)->files[type])) {
+		quota_error(sb, "Number of blocks too big for quota file size (%llu > %llu).",
+		    (loff_t)qinfo->dqi_blocks << qinfo->dqi_blocksize_bits,
+		    i_size_read(sb_dqopt(sb)->files[type]));
+		goto out;
+	}
+	if (qinfo->dqi_free_blk >= qinfo->dqi_blocks) {
+		quota_error(sb, "Free block number too big (%u >= %u).",
+			    qinfo->dqi_free_blk, qinfo->dqi_blocks);
+		goto out;
+	}
+	if (qinfo->dqi_free_entry >= qinfo->dqi_blocks) {
+		quota_error(sb, "Block with free entry too big (%u >= %u).",
+			    qinfo->dqi_free_entry, qinfo->dqi_blocks);
+		goto out;
+	}
 	ret = 0;
 out:
 	up_read(&dqopt->dqio_sem);
-- 
2.16.4

