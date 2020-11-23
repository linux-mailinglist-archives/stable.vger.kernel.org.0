Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC36F2C0B56
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388388AbgKWNXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730646AbgKWMf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:35:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF6302065E;
        Mon, 23 Nov 2020 12:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134928;
        bh=aNyI+XuCBtY/W1nfHWgC6jRn7Qpr6fXjvl1WXNpFmW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNVbCgkl35tpApnRa5V0QoeHSjXcp5o+ko5MBkZBEMHg0HbVNpKXX1ezS9DKNRlD3
         R+oCOwrn2/SGD/uX38ljGOAkVetk6GCzTtDbeFHa/Bwn4jO+Wn/QTdjrJP44lcEp8U
         XyUdxQqpu+URXIUBjZViySxvTuWhXgzYLFVAbolc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/158] gfs2: fix possible reference leak in gfs2_check_blk_type
Date:   Mon, 23 Nov 2020 13:21:10 +0100
Message-Id: <20201123121821.956593197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
index 3d5aa0c10a4c1..5d9d93ca0db70 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2574,13 +2574,13 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 
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



