Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFB2B5FD4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgKQM65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgKQM5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 511742225E;
        Tue, 17 Nov 2020 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617861;
        bh=4b3LcdyrpWcdzKVID58KAgkLxYPmc8Oeo+vJp7JUGXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOx+O5c83/2MMmYBcLsGBeT1ANDrpeMuluo/pCbekz46eizOxuLWLWPLCzP8Zl8ES
         H2GUli9RtXWR8bVYajTKCf7btCnBbD6P7LdPEKEzrs+SP1bo7pVvf5uY9sQFfsh2eL
         dwWurEO7wMNoQqyv5xMKKcBwo1fhbTQkDyCn4RWE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 10/11] gfs2: fix possible reference leak in gfs2_check_blk_type
Date:   Tue, 17 Nov 2020 07:57:24 -0500
Message-Id: <20201117125725.599833-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125725.599833-1-sashal@kernel.org>
References: <20201117125725.599833-1-sashal@kernel.org>
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
index 2466bb44a23c5..2dfcea5a71153 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2571,13 +2571,13 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 
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

