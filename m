Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3484157A31
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgBJNVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbgBJMhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:34 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8615E208C4;
        Mon, 10 Feb 2020 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338254;
        bh=eNbSzKnGhFlJ968LROIwRDi3+9NQV0GsMHanD6wDiTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXnifRD257a0s9m7BIHRLyzjOi61vVv+hUIzyAsx+puM+V6ELUETg2vaIImG5Cao8
         I/wCrtE6QAkuySw5CSRa2I4AHvA2htorG9hj2SseiTh5lJE6eZfPUTUh9gNavV8iT3
         vd/Yv3T8WIVq0hpuTECoP99hBsx5W3OSHLfhXfGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 120/309] f2fs: code cleanup for f2fs_statfs_project()
Date:   Mon, 10 Feb 2020 04:31:16 -0800
Message-Id: <20200210122418.024104188@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -1213,12 +1213,8 @@ static int f2fs_statfs_project(struct su
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
 
@@ -1230,12 +1226,8 @@ static int f2fs_statfs_project(struct su
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


