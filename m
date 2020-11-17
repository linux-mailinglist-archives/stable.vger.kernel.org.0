Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B682B5FE3
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgKQM7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgKQM5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 403882464E;
        Tue, 17 Nov 2020 12:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617838;
        bh=bA3X+duKvGEWB8VUml7ylvhLAUsM3ZE0/oXloRMssRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFafAI6OIW9AL+5EaWGTho3ZIG23P8lPX9ymGzQLUatfAlFONUyf9QfAJE2XxvdxT
         7g1fPSRpJ/rGMBLSv5JIDcVgOPbXwFBBLD98Rmf7m/Ih6wWjezrfVCotUVz4MNmMoE
         /ePCsY08a+WGsfh3oF2/upqA3qWQ84ookjYcXX38=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 16/21] gfs2: fix possible reference leak in gfs2_check_blk_type
Date:   Tue, 17 Nov 2020 07:56:47 -0500
Message-Id: <20201117125652.599614-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit bc923818b190c8b63c91a47702969c8053574f5b ]

In the fail path of gfs2_check_blk_type, forgetting to call
gfs2_glock_dq_uninit will result in rgd_gh reference leak.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 1bba5a9d45fa3..fc073cb729854 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2530,13 +2530,13 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 
 	rbm.rgd = rgd;
 	error = gfs2_rbm_from_block(&rbm, no_addr);
-	if (WARN_ON_ONCE(error))
-		goto fail;
-
-	if (gfs2_testbit(&rbm, false) != type)
-		error = -ESTALE;
+	if (!WARN_ON_ONCE(error)) {
+		if (gfs2_testbit(&rbm, false) != type)
+			error = -ESTALE;
+	}
 
 	gfs2_glock_dq_uninit(&rgd_gh);
+
 fail:
 	return error;
 }
-- 
2.27.0

