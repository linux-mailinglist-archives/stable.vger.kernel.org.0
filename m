Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE8DFA129
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfKMBzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbfKMBzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7C21222D3;
        Wed, 13 Nov 2019 01:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610120;
        bh=84uaRIPv5X8QlnjzO78ZiN4sPge0T8QMfyyMtrZ2xiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5wJmubxEpB+tNULJnuEZ4FCvsQOZJKKzxGsYvN2IMHiWokj7CY1NXKaqRMNn3q7V
         0KpDTyYOVJfugSw35bN4oswOJUzQhc3ecW6DIn5wDp8Xtoi9SnDyClGexIpXnUXv3D
         N8x0H+WvfcETweo6iYlhyHl2BcUzhmSZjErgBUcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhoujie Wu <zjwu@marvell.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 175/209] lightnvm: pblk: consider max hw sectors supported for max_write_pgs
Date:   Tue, 12 Nov 2019 20:49:51 -0500
Message-Id: <20191113015025.9685-175-sashal@kernel.org>
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

