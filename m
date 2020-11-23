Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F102C07C4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733161AbgKWMn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733160AbgKWMn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A4E20857;
        Mon, 23 Nov 2020 12:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135438;
        bh=DKkEutsNNEgL7gdgdJMWMhSEVqGgTmR+8TxCP+Llo4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifA25yPS4a0PuTYKMfPj0S1oxaO6kNMYsF6kFKSNtli4MEyVE90aSBDXPvmmZXPJ+
         zutNCeBgbXXlr2ZhpVIY2UJIH0BCu2RD2nxzUj0KVd/MaI/4wZ+Clg0SgkaL/rPUrr
         +JIyTMwpM8zI1aN1jn7tIQcFsEItYluvQXaKiaKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 068/252] gfs2: fix possible reference leak in gfs2_check_blk_type
Date:   Mon, 23 Nov 2020 13:20:18 +0100
Message-Id: <20201123121838.869579559@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ac306895bbbcc..d035309cedd0d 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2533,13 +2533,13 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 
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



