Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CCFFA4E3
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfKMBzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729036AbfKMBzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B602922459;
        Wed, 13 Nov 2019 01:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610113;
        bh=m1A12Zj/jy/JTBMwyfGQv0k10etCIufpYcn/+2wqQ04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMsnraZ0aE5AYqIWj+hVLAQPb1cCL70OthNcQe49ikOpnvfojR2/YO9cmOgk2atXH
         CDX7VwtJP0WYrQ2eJwmBPST0wvXBGlfoxevFzeKH13qT9vyS8K6ezdB6DxT9l00Gmq
         4w0VAe5YJEboAdZzJ9isZx3dX1UkmMUICc4APr6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 169/209] lightnvm: pblk: fix incorrect min_write_pgs
Date:   Tue, 12 Nov 2019 20:49:45 -0500
Message-Id: <20191113015025.9685-169-sashal@kernel.org>
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

[ Upstream commit 8bbd45d02a118cbefdf4e1a6274bd965a6aa3c59 ]

The calculation of pblk->min_write_pgs should only use the optimal
write size attribute provided by the drive, it does not correlate to
the memory page size of the system, which can be smaller or larger
than the LBA size reported.

Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Reviewed-by: Javier González <javier@cnexlabs.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index 537e98f2b24a2..145922589b0c6 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -371,7 +371,7 @@ static int pblk_core_init(struct pblk *pblk)
 	atomic64_set(&pblk->nr_flush, 0);
 	pblk->nr_flush_rst = 0;
 
-	pblk->min_write_pgs = geo->ws_opt * (geo->csecs / PAGE_SIZE);
+	pblk->min_write_pgs = geo->ws_opt;
 	max_write_ppas = pblk->min_write_pgs * geo->all_luns;
 	pblk->max_write_pgs = min_t(int, max_write_ppas, NVM_MAX_VLBA);
 	pblk_set_sec_per_write(pblk, pblk->min_write_pgs);
-- 
2.20.1

