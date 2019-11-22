Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F5C106DE3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbfKVLEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731520AbfKVLEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B16E20679;
        Fri, 22 Nov 2019 11:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420650;
        bh=m1A12Zj/jy/JTBMwyfGQv0k10etCIufpYcn/+2wqQ04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCnj+nP7bMEyAEpoMtfapDd9lZPCQzIvUZgIw5LgUCpKAUsP8YgbEASE06Ur+lhyJ
         Q7TKAR18DmzCUQHrVcgjUMdBMbZt0HZ+K/dRCftIwr5/xjYEosx6MbYkVc0uGgJn/v
         NKq5Zl5KP/LDUCMd464zlaU3WUT8CXXYqPlavkkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/220] lightnvm: pblk: fix incorrect min_write_pgs
Date:   Fri, 22 Nov 2019 11:29:05 +0100
Message-Id: <20191122100927.187736359@linuxfoundation.org>
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



