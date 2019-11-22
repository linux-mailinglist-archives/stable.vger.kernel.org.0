Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F195B106E57
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfKVLE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730972AbfKVLE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27E3B207FC;
        Fri, 22 Nov 2019 11:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420667;
        bh=84uaRIPv5X8QlnjzO78ZiN4sPge0T8QMfyyMtrZ2xiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kM/0Nrl3kvMLjT02ip46+llrMtWO3cdOsMYy3zMi3/XDTDAd68Hw5KxVBv9gDZWi2
         mCopFu7hg3LaIAogXDm1ePmSuH1BEl7hT6gIPZg4bIDrkJSoZi6h2vQdBkTfK6Hk6n
         b+z94wLgghqE0M238HtSM2X3KiPqO8wuPqv141ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhoujie Wu <zjwu@marvell.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/220] lightnvm: pblk: consider max hw sectors supported for max_write_pgs
Date:   Fri, 22 Nov 2019 11:29:11 +0100
Message-Id: <20191122100927.586039674@linuxfoundation.org>
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

From: Zhoujie Wu <zjwu@marvell.com>

[ Upstream commit 8a57fc3823d08edb1661a06d9e0a8c2365ac561e ]

When do GC, the number of read/write sectors are determined
by max_write_pgs(see gc_rq preparation in pblk_gc_line_prepare_ws).

Due to max_write_pgs doesn't consider max hw sectors
supported by nvme controller(128K), which leads to GC
tries to read 64 * 4K in one command, and see below error
caused by pblk_bio_map_addr in function pblk_submit_read_gc.

[ 2923.005376] pblk: could not add page to bio
[ 2923.005377] pblk: could not allocate GC bio (18446744073709551604)

Signed-off-by: Zhoujie Wu <zjwu@marvell.com>
Reviewed-by: Javier González <javier@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index 91fd2b291db91..88b632787abd6 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -375,6 +375,8 @@ static int pblk_core_init(struct pblk *pblk)
 	pblk->min_write_pgs = geo->ws_opt;
 	max_write_ppas = pblk->min_write_pgs * geo->all_luns;
 	pblk->max_write_pgs = min_t(int, max_write_ppas, NVM_MAX_VLBA);
+	pblk->max_write_pgs = min_t(int, pblk->max_write_pgs,
+		queue_max_hw_sectors(dev->q) / (geo->csecs >> SECTOR_SHIFT));
 	pblk_set_sec_per_write(pblk, pblk->min_write_pgs);
 
 	if (pblk->max_write_pgs > PBLK_MAX_REQ_ADDRS) {
-- 
2.20.1



