Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04CE1574D0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBJMgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgBJMgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:01 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDBBA20863;
        Mon, 10 Feb 2020 12:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338161;
        bh=9Vtt4RMkJOeOyK/O7Mi2scBa7KdVJ9YUq0t/z0Gh2mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nn81+oT8T7Kll39LA+oSNB+0qGkMn8OUZRMl2vfa5yckSuNkH0/GKoVkFa8CypXGJ
         BkvwETaiDH5zZTsDZT5g2XxvjrjwTC1gP++3UEqSXeYbRrHeu5ygNjP5r/cYhS7m/9
         /pQREgUFgbP7KBUnvzZ9ksvJXhiQvmvO6ugXFAg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 083/195] f2fs: code cleanup for f2fs_statfs_project()
Date:   Mon, 10 Feb 2020 04:32:21 -0800
Message-Id: <20200210122313.632723451@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

commit bf2cbd3c57159c2b639ee8797b52ab5af180bf83 upstream.

Calling min_not_zero() to simplify complicated prjquota
limit comparison in f2fs_statfs_project().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/super.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1148,12 +1148,8 @@ static int f2fs_statfs_project(struct su
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_bsoftlimit)
-		limit = dquot->dq_dqb.dqb_bsoftlimit;
-	if (dquot->dq_dqb.dqb_bhardlimit &&
-			(!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
-		limit = dquot->dq_dqb.dqb_bhardlimit;
+	limit = min_not_zero(dquot->dq_dqb.dqb_bsoftlimit,
+					dquot->dq_dqb.dqb_bhardlimit);
 	if (limit)
 		limit >>= sb->s_blocksize_bits;
 
@@ -1165,12 +1161,8 @@ static int f2fs_statfs_project(struct su
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_isoftlimit)
-		limit = dquot->dq_dqb.dqb_isoftlimit;
-	if (dquot->dq_dqb.dqb_ihardlimit &&
-			(!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
-		limit = dquot->dq_dqb.dqb_ihardlimit;
+	limit = min_not_zero(dquot->dq_dqb.dqb_isoftlimit,
+					dquot->dq_dqb.dqb_ihardlimit);
 
 	if (limit && buf->f_files > limit) {
 		buf->f_files = limit;


