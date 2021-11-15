Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64994522D2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349603AbhKPBQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244517AbhKOTPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB27F632C1;
        Mon, 15 Nov 2021 18:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000507;
        bh=/JddBWnmxlu66qfNt8DF/M/IEQixJTQpsPYN+2VCSYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMcNTyXU/AQKTsXJ3oh2Ku41yDB/O7iOnJVOQX+cyyQISumQA7/cWLZjJqdoWbnqk
         3U6FSi2FhiTVryJF9+67bStm/8Ilgyi7OOl6a/OFNGAeKQjYTooI44rZf/nENbFr3i
         hg5U1paI5Spd3ecq8PHiiFPvwN97BOmD9VgmF6Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 686/849] fs: orangefs: fix error return code of orangefs_revalidate_lookup()
Date:   Mon, 15 Nov 2021 18:02:49 +0100
Message-Id: <20211115165443.472913315@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



