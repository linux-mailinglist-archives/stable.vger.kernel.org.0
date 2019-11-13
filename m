Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23445FA4E5
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfKMBzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbfKMBzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8248E22470;
        Wed, 13 Nov 2019 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610112;
        bh=7gw2hzPD+NzEGUoM3K2TyQAxcHH4cIB6feJwbfAhmAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmz0wMIJ6BRZNGXPcOkb3VHMDRh7kMkKUMagGoUmj+FyM4EGhCECuYLsItrCaeUo3
         el1Ogm0I1dIkaGWdQ/73GtBLFCqK/+SW4YnedHoaTkPpNQ6aVfuYiCuOC1oaP4921C
         UZp0Ag9Meo20lPnm6JokjJ17OooJX/T6sbLEZ9IU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        Hans Holmberg <hans.holmberg@cnexlabs.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 168/209] lightnvm: pblk: fix rqd.error return value in pblk_blk_erase_sync
Date:   Tue, 12 Nov 2019 20:49:44 -0500
Message-Id: <20191113015025.9685-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matias Bjørling <mb@lightnvm.io>

[ Upstream commit 4b5d56edb8fc565c5db029aecaea598eadfba7f6 ]

rqd.error is masked by the return value of pblk_submit_io_sync.
The rqd structure is then passed on to the end_io function, which
assumes that any error should lead to a chunk being marked
offline/bad. Since the pblk_submit_io_sync can fail before the
command is issued to the device, the error value maybe not correspond
to a media failure, leading to chunks being immaturely retired.

Also, the pblk_blk_erase_sync function prints an error message in case
the erase fails. Since the caller prints an error message by itself,
remove the error message in this function.

Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Reviewed-by: Javier González <javier@cnexlabs.com>
Reviewed-by: Hans Holmberg <hans.holmberg@cnexlabs.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-core.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/lightnvm/pblk-core.c b/drivers/lightnvm/pblk-core.c
index 80710c62ac293..fd322565fb0f9 100644
--- a/drivers/lightnvm/pblk-core.c
+++ b/drivers/lightnvm/pblk-core.c
@@ -893,10 +893,8 @@ static void pblk_setup_e_rq(struct pblk *pblk, struct nvm_rq *rqd,
 
 static int pblk_blk_erase_sync(struct pblk *pblk, struct ppa_addr ppa)
 {
-	struct nvm_rq rqd;
-	int ret = 0;
-
-	memset(&rqd, 0, sizeof(struct nvm_rq));
+	struct nvm_rq rqd = {NULL};
+	int ret;
 
 	pblk_setup_e_rq(pblk, &rqd, ppa);
 
@@ -904,19 +902,6 @@ static int pblk_blk_erase_sync(struct pblk *pblk, struct ppa_addr ppa)
 	 * with writes. Thus, there is no need to take the LUN semaphore.
 	 */
 	ret = pblk_submit_io_sync(pblk, &rqd);
-	if (ret) {
-		struct nvm_tgt_dev *dev = pblk->dev;
-		struct nvm_geo *geo = &dev->geo;
-
-		pblk_err(pblk, "could not sync erase line:%d,blk:%d\n",
-					pblk_ppa_to_line(ppa),
-					pblk_ppa_to_pos(geo, ppa));
-
-		rqd.error = ret;
-		goto out;
-	}
-
-out:
 	rqd.private = pblk;
 	__pblk_end_io_erase(pblk, &rqd);
 
-- 
2.20.1

