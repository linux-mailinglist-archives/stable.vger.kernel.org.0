Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB49328AEC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbhCASZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239516AbhCASTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A762651C2;
        Mon,  1 Mar 2021 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619003;
        bh=SOuethk+Lvc1B4JliQnmJZw9lJz2/4JjD2WjtCynslo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqz8LaUkvcb82sUZTEfvVTg8FN9lo+NX4War9HkE/VW9np39dWVpjfCVJg4Ptl34I
         PGTk9ZnpV6ZEK21lZSll4jk3XaOJ2c/cyZSCe/hjBRqVuPcCXCcR3X5ROfWUZZuYAK
         AXr9jpriZMoY/a6g6GEKNJ7D7dmLrBfjwqrih7fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+77779c9b52ab78154b08@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/663] quota: Fix memory leak when handling corrupted quota file
Date:   Mon,  1 Mar 2021 17:08:34 +0100
Message-Id: <20210301161154.974457068@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit a4db1072e1a3bd7a8d9c356e1902b13ac5deb8ef ]

When checking corrupted quota file we can bail out and leak allocated
info structure. Properly free info structure on error return.

Reported-by: syzbot+77779c9b52ab78154b08@syzkaller.appspotmail.com
Fixes: 11c514a99bb9 ("quota: Sanity-check quota file headers on load")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/quota_v2.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index c21106557a37e..b1467f3921c28 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -164,19 +164,24 @@ static int v2_read_file_info(struct super_block *sb, int type)
 		quota_error(sb, "Number of blocks too big for quota file size (%llu > %llu).",
 		    (loff_t)qinfo->dqi_blocks << qinfo->dqi_blocksize_bits,
 		    i_size_read(sb_dqopt(sb)->files[type]));
-		goto out;
+		goto out_free;
 	}
 	if (qinfo->dqi_free_blk >= qinfo->dqi_blocks) {
 		quota_error(sb, "Free block number too big (%u >= %u).",
 			    qinfo->dqi_free_blk, qinfo->dqi_blocks);
-		goto out;
+		goto out_free;
 	}
 	if (qinfo->dqi_free_entry >= qinfo->dqi_blocks) {
 		quota_error(sb, "Block with free entry too big (%u >= %u).",
 			    qinfo->dqi_free_entry, qinfo->dqi_blocks);
-		goto out;
+		goto out_free;
 	}
 	ret = 0;
+out_free:
+	if (ret) {
+		kfree(info->dqi_priv);
+		info->dqi_priv = NULL;
+	}
 out:
 	up_read(&dqopt->dqio_sem);
 	return ret;
-- 
2.27.0



