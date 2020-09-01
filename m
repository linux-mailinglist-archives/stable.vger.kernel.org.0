Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF342598F3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgIAPaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbgIAPaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F85206EB;
        Tue,  1 Sep 2020 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974254;
        bh=5nlWCuWIm7npu4Fda4YzVL0ATK2lwj9iiU7vzapDB98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTMoElE6UTLnSDtbZQWx+CH3g8K/ffPDadRsKbjx1qSUq5a08QMaYjv/JDmuqpTl8
         D9N0kA8WNu26evNHKeec4IJ1agogFJKKgKlV5vKOkctXY+SqpJKTjz1MeOE2fMcPDp
         aVRZ08/Op/U5xJtHmCx3D+1D23sZnywIiLGD/E3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/214] blkcg: fix memleak for iolatency
Date:   Tue,  1 Sep 2020 17:09:46 +0200
Message-Id: <20200901150958.067453405@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit 27029b4b18aa5d3b060f0bf2c26dae254132cfce ]

Normally, blkcg_iolatency_exit() will free related memory in iolatency
when cleanup queue. But if blk_throtl_init() return error and queue init
fail, blkcg_iolatency_exit() will not do that for us. Then it cause
memory leak.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1eb8895be4c6b..0c7addcd19859 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1219,13 +1219,15 @@ int blkcg_init_queue(struct request_queue *q)
 	if (preloaded)
 		radix_tree_preload_end();
 
-	ret = blk_iolatency_init(q);
+	ret = blk_throtl_init(q);
 	if (ret)
 		goto err_destroy_all;
 
-	ret = blk_throtl_init(q);
-	if (ret)
+	ret = blk_iolatency_init(q);
+	if (ret) {
+		blk_throtl_exit(q);
 		goto err_destroy_all;
+	}
 	return 0;
 
 err_destroy_all:
-- 
2.25.1



