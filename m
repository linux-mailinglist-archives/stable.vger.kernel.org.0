Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17676FA48D
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfKMBzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbfKMBzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF7C522459;
        Wed, 13 Nov 2019 01:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610119;
        bh=m5hJaHVZrLSf1mJK7b9kB9bQlJxzbNzPsHf/khSsGYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tknK1Y175UjN4Bp6DkunMod6WVv5KmGe/ZCsxGjoSr5HlXjvZWupQtAntXc0VM3/w
         PynHgwI5KApOh8nZaoVsIqXyQEtJXNmSFlsoVQzEK1cAPF5NBcF/1vC5bXic1gcTsB
         CFf3DOFKca/aS0dTDu4kn4NLlpf1hWYWO4Q+PrHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hans Holmberg <hans.holmberg@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 174/209] lightnvm: pblk: fix error handling of pblk_lines_init()
Date:   Tue, 12 Nov 2019 20:49:50 -0500
Message-Id: <20191113015025.9685-174-sashal@kernel.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit a70985f83c625a5eaf618be81621e5e4521a66c6 ]

In the too many bad blocks error handling case, we should release all
the allocated resources, otherwise it will cause memory leak.

Fixes: 2deeefc02dff ("lightnvm: pblk: fail gracefully on line alloc. failure")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Hans Holmberg <hans.holmberg@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index dc32274881b2f..91fd2b291db91 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -1084,7 +1084,8 @@ static int pblk_lines_init(struct pblk *pblk)
 
 	if (!nr_free_chks) {
 		pblk_err(pblk, "too many bad blocks prevent for sane instance\n");
-		return -EINTR;
+		ret = -EINTR;
+		goto fail_free_lines;
 	}
 
 	pblk_set_provision(pblk, nr_free_chks);
-- 
2.20.1

