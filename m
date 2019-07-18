Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427966C5D4
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfGRDKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389610AbfGRDKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:12 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CDBD2053B;
        Thu, 18 Jul 2019 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419411;
        bh=kzkmZ7qim7oRH84vOOV93VugboVAnSZZdaQjUey2iEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQwO6aFGuSIJOhOyb7a1UC//LapG8dCVRJUbyO7iz6rUzMrIMmQO78Udg+s/uTTlj
         uKFQGmX4bSAsNeOXrN5zDEOYIH0RJihYmrJCVWVn89rxG/F9Y+iPGtSCV1pew067OQ
         W9X9wjRstAPgp/SHvrsHOehBpNzQ3symr9dXWhN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/80] quota: fix a problem about transfer quota
Date:   Thu, 18 Jul 2019 12:01:28 +0900
Message-Id: <20190718030101.509941306@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c6d9c35d16f1bafd3fec64b865e569e48cbcb514 ]

Run below script as root, dquot_add_space will return -EDQUOT since
__dquot_transfer call dquot_add_space with flags=0, and dquot_add_space
think it's a preallocation. Fix it by set flags as DQUOT_SPACE_WARN.

mkfs.ext4 -O quota,project /dev/vdb
mount -o prjquota /dev/vdb /mnt
setquota -P 23 1 1 0 0 /dev/vdb
dd if=/dev/zero of=/mnt/test-file bs=4K count=1
chattr -p 23 test-file

Fixes: 7b9ca4c61bc2 ("quota: Reduce contention on dq_data_lock")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 4cd0c2336624..9c81fd973418 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1989,8 +1989,8 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 				       &warn_to[cnt]);
 		if (ret)
 			goto over_quota;
-		ret = dquot_add_space(transfer_to[cnt], cur_space, rsv_space, 0,
-				      &warn_to[cnt]);
+		ret = dquot_add_space(transfer_to[cnt], cur_space, rsv_space,
+				      DQUOT_SPACE_WARN, &warn_to[cnt]);
 		if (ret) {
 			spin_lock(&transfer_to[cnt]->dq_dqb_lock);
 			dquot_decr_inodes(transfer_to[cnt], inode_usage);
-- 
2.20.1



