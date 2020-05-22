Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC7B1DEA39
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgEVOwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730848AbgEVOwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:52:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 458C020756;
        Fri, 22 May 2020 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159128;
        bh=3XN0dCs4ELVpk+KvkOC2xhVH8DurHvnfoxL0UtPiEI0=;
        h=From:To:Cc:Subject:Date:From;
        b=FcJnA0kBuW6+/gELb59Q/gLzJpfOt9dPCngcaOjxk9mVpp0JH0HknpoKkf/Q3nlzI
         2Nu0GafocT0Mlcwsofsnf6jxLjWl/9ExTU6MZGb/m8Hm9wjWl8aNPJZ3enXXQbF3pU
         2YjIdaDfEkLdB8BS9bsJM7AIEPq58P8zt2kfZE5o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.4 1/5] gfs2: don't call quota_unhold if quotas are not locked
Date:   Fri, 22 May 2020 10:52:03 -0400
Message-Id: <20200522145207.435314-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit c9cb9e381985bbbe8acd2695bbe6bd24bf06b81c ]

Before this patch, function gfs2_quota_unlock checked if quotas are
turned off, and if so, it branched to label out, which called
gfs2_quota_unhold. With the new system of gfs2_qa_get and put, we
no longer want to call gfs2_quota_unhold or we won't balance our
gets and puts.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 3a31226531ea..4af00ed4960a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1080,7 +1080,7 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 	int found;
 
 	if (!test_and_clear_bit(GIF_QD_LOCKED, &ip->i_flags))
-		goto out;
+		return;
 
 	for (x = 0; x < ip->i_res->rs_qa_qd_num; x++) {
 		struct gfs2_quota_data *qd;
@@ -1117,7 +1117,6 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 			qd_unlock(qda[x]);
 	}
 
-out:
 	gfs2_quota_unhold(ip);
 }
 
-- 
2.25.1

