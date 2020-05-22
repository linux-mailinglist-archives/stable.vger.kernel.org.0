Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54211DEB2A
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgEVO6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730580AbgEVOuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:50:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5DE02072C;
        Fri, 22 May 2020 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159017;
        bh=/DgzylOsyp9DnIpSDwr09rBAEMLqWYmSe5+ItFRSM0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV5mxUq/+tR9HdN19MAbXZlAJ2FhP8roR62KbSGDEceHz3yYIC30Kyrx+huRZjy3w
         3o33AWiHqxKQ5lv0ITUDEKCqXYQeAdkPwRcly03Q7HlJ15M+mBCqgtsCZVv6Q7wq89
         pYWGTuIrwG9X4hT2zzFV4NMMR8xEbl1SjrmtMCR4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.6 15/41] gfs2: don't call quota_unhold if quotas are not locked
Date:   Fri, 22 May 2020 10:49:32 -0400
Message-Id: <20200522144959.434379-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522144959.434379-1-sashal@kernel.org>
References: <20200522144959.434379-1-sashal@kernel.org>
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
index 832d44782f74..a80b638b582e 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1113,7 +1113,7 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 	int found;
 
 	if (!test_and_clear_bit(GIF_QD_LOCKED, &ip->i_flags))
-		goto out;
+		return;
 
 	for (x = 0; x < ip->i_qadata->qa_qd_num; x++) {
 		struct gfs2_quota_data *qd;
@@ -1150,7 +1150,6 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 			qd_unlock(qda[x]);
 	}
 
-out:
 	gfs2_quota_unhold(ip);
 }
 
-- 
2.25.1

