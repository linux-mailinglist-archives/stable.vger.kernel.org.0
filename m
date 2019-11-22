Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B63106E6E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfKVLEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbfKVLEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C11B20659;
        Fri, 22 Nov 2019 11:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420646;
        bh=7gw2hzPD+NzEGUoM3K2TyQAxcHH4cIB6feJwbfAhmAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooKUYFlt2+NJ/kHoP9YolDACVHdKCR4XbWXFxV/3miRkhLA+qbjPgIEx38qYM/UeC
         5wUfJ62nLAHHJwsyzIyOv9g/UWr43jv35mDiSQBHenB3Svko+fuIjCrO7xUUPSeyzd
         d5ZT3HrsLtp5qxpx1uJcIq9MVojyK223HzAL8Imk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        Hans Holmberg <hans.holmberg@cnexlabs.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 179/220] lightnvm: pblk: fix rqd.error return value in pblk_blk_erase_sync
Date:   Fri, 22 Nov 2019 11:29:04 +0100
Message-Id: <20191122100926.291925470@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



