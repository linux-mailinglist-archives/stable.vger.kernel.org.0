Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADC1451EE0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355383AbhKPAhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344707AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A96F632A8;
        Mon, 15 Nov 2021 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002966;
        bh=lLMuEEFaKjw9M8dw519hu8ZMtpFyvxWEIm3jQN84xiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujiRBoDLz5kv8FEJNy+as0mI7aVx8Obd/S6nuz7No1o6gfyAU5g4CUasClp7XdsFD
         bBuD27YCcDDbgflL/ZOP1CsNkxh60ey7dnl1xiYaEQRqtLSudq89FBUh4VL789uO/6
         ahZwB7+kX6SnrGCHifKc388KHxpdeVAuBFfgqcI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 761/917] nbd: fix possible overflow for first_minor in nbd_dev_add()
Date:   Mon, 15 Nov 2021 18:04:16 +0100
Message-Id: <20211115165454.729470064@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 940c264984fd1457918393c49674f6b39ee16506 ]

If 'part_shift' is not zero, then 'index << part_shift' might
overflow to a value that is not greater than '0xfffff', then sysfs
might complains about duplicate creation.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-3-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 0d820c4dec176..577c7dba5d78d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1749,11 +1749,11 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	disk->major = NBD_MAJOR;
 
 	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since MKDEV() expect that the max bits of
-	 * first_minor is 20.
+	 * sysfs files/links, since index << part_shift might overflow, or
+	 * MKDEV() expect that the max bits of first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > MINORMASK) {
+	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}
-- 
2.33.0



