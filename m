Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5982127E9C
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfLTOsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbfLTOry (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:47:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D01E222C2;
        Fri, 20 Dec 2019 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576853274;
        bh=vLI2cEKTfZm4QqhOpvMV2XjvSO5PrjRmRt0HYraxTb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=if8jc+3CLdMioVqR8ELAC3vnE/heI05h1kC2xXWfSITqmTMXWJeQsPnf2xzDHZnly
         0doeFa6a1x/MWi7bZ+iiJ15mDuc9msLY850YgmZqL8mKjcQDKmQ+/XocyUswmsFevG
         QlsH6KX4C6+KRkXLlmaMapn5Kve8XjUWsGxhYIsI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/11] md: raid1: check rdev before reference in raid1_sync_request func
Date:   Fri, 20 Dec 2019 09:47:40 -0500
Message-Id: <20191220144744.10565-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220144744.10565-1-sashal@kernel.org>
References: <20191220144744.10565-1-sashal@kernel.org>
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
index abb99515068b1..096f3a2ba5244 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2630,7 +2630,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
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

