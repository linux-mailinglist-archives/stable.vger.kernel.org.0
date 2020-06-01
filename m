Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989B51EA8FE
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgFAR5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbgFAR5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DD2206E2;
        Mon,  1 Jun 2020 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034263;
        bh=WFV9FyCjkInEb5OHKvtcQ60D6GXHMa7bdHtkAceNB6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkzy4MfqQUmizvhHrAHxX/hOcwrPcyREO2Af7Vi00AMisDM3ijbvvh22RLLl5IH9X
         Hnx45WOGRFG6YO/mAmMF7L6/aH2ZO4krebCbw7WZDfbn7ugwgscaVkp3mn9fv1HXB5
         l2nJkhCiwl9dJut3/76N68EIS0R8zKSupIGJYDhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/61] gfs2: dont call quota_unhold if quotas are not locked
Date:   Mon,  1 Jun 2020 19:53:23 +0200
Message-Id: <20200601174014.832657179@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fb9b1d702351..fb2e0ad945bf 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1112,7 +1112,7 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 	int found;
 
 	if (!test_and_clear_bit(GIF_QD_LOCKED, &ip->i_flags))
-		goto out;
+		return;
 
 	for (x = 0; x < ip->i_qadata->qa_qd_num; x++) {
 		struct gfs2_quota_data *qd;
@@ -1149,7 +1149,6 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 			qd_unlock(qda[x]);
 	}
 
-out:
 	gfs2_quota_unhold(ip);
 }
 
-- 
2.25.1



