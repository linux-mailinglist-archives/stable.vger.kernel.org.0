Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D22145C095
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346671AbhKXNJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347979AbhKXNIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:08:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9252F61A60;
        Wed, 24 Nov 2021 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757551;
        bh=/JddBWnmxlu66qfNt8DF/M/IEQixJTQpsPYN+2VCSYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YriO8GgEcij6rla4F6lir8ANhT35qxa1y7bcsEFeUiy30VsaSSGwafSx0k5rjyXM0
         delr8l+bcDQUOinLZS5yh6vLRdLbcSPBTvFpAwbqrO5hc//qyf373WTYs0gOgMD2A1
         MYfEE4rFFLNkJ/728XetK0iR2Ycuo6NaCFwdnH1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 206/323] fs: orangefs: fix error return code of orangefs_revalidate_lookup()
Date:   Wed, 24 Nov 2021 12:56:36 +0100
Message-Id: <20211124115725.894346440@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 4c2b46c824a78fc8190d8eafaaea5a9078fe7479 ]

When op_alloc() returns NULL to new_op, no error return code of
orangefs_revalidate_lookup() is assigned.
To fix this bug, ret is assigned with -ENOMEM in this case.

Fixes: 8bb8aefd5afb ("OrangeFS: Change almost all instances of the string PVFS2 to OrangeFS.")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/dcache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/dcache.c b/fs/orangefs/dcache.c
index fe484cf93e5cd..8bbe9486e3a62 100644
--- a/fs/orangefs/dcache.c
+++ b/fs/orangefs/dcache.c
@@ -26,8 +26,10 @@ static int orangefs_revalidate_lookup(struct dentry *dentry)
 	gossip_debug(GOSSIP_DCACHE_DEBUG, "%s: attempting lookup.\n", __func__);
 
 	new_op = op_alloc(ORANGEFS_VFS_OP_LOOKUP);
-	if (!new_op)
+	if (!new_op) {
+		ret = -ENOMEM;
 		goto out_put_parent;
+	}
 
 	new_op->upcall.req.lookup.sym_follow = ORANGEFS_LOOKUP_LINK_NO_FOLLOW;
 	new_op->upcall.req.lookup.parent_refn = parent->refn;
-- 
2.33.0



