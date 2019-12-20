Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8370E127E80
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfLTOrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:47:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727615AbfLTOrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:47:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1BD24679;
        Fri, 20 Dec 2019 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576853229;
        bh=vOWJl/FwdZ6SaPEm1U9jWsr8pbWL/1mh+kI9cCIMa5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeR4HC9PE9IdUY6tsrMx1zfRGrVceRUbnwpD5uqmE0yPkMP8/j7FEOjnv1hKZZw/I
         +2HQgt4XzjvQ63UVNpBv2FilYxK3EWG3LrFsx7nAN0uGSuNvEEv0fi966zdHYvv0kz
         VweKQr8aYc7+6ub1mszCu6J9XSbGfGulF+q7ojk8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/14] md: raid1: check rdev before reference in raid1_sync_request func
Date:   Fri, 20 Dec 2019 09:46:52 -0500
Message-Id: <20191220144658.10414-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220144658.10414-1-sashal@kernel.org>
References: <20191220144658.10414-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

[ Upstream commit 028288df635f5a9addd48ac4677b720192747944 ]

In raid1_sync_request func, rdev should be checked before reference.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9892c41de4419..8a50da4f148f9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2633,7 +2633,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				write_targets++;
 			}
 		}
-		if (bio->bi_end_io) {
+		if (rdev && bio->bi_end_io) {
 			atomic_inc(&rdev->nr_pending);
 			bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
-- 
2.20.1

