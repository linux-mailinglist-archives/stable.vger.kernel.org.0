Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440C4257DBC
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgHaPkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbgHaP3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD7C20767;
        Mon, 31 Aug 2020 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887793;
        bh=Va+uG3982E/A+B5LOqE36PWBGeYhfsCtVJhExIKAmXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=za9rohnoRqlV6zkmXx7+X0B8qbEjhsDVHGtNoTAhB5nm8TUle5PcOdlgm8AOJ4qKy
         DRrp+lLS81VyOB1G9ZA0LPXsiX0oG/HTO6Kq0hKCWORq4b1XvYSEU2pjMqRW6QGqS7
         P3svqIMya753FiOhvlq5ruwqnHhygZ614cBRK1SQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 11/42] nvme: skip noiob for zoned devices
Date:   Mon, 31 Aug 2020 11:29:03 -0400
Message-Id: <20200831152934.1023912-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c41ad98bebb8f4f0335b3c50dbb7583a6149dce4 ]

Zoned block devices reuse the chunk_sectors queue limit to define zone
boundaries. If a such a device happens to also report an optimal
boundary, do not use that to define the chunk_sectors as that may
intermittently interfere with io splitting and zone size queries.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f38548e6d55ec..6ea0bab621df3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1975,7 +1975,7 @@ static int __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 		}
 	}
 
-	if (iob)
+	if (iob && !blk_queue_is_zoned(ns->queue))
 		blk_queue_chunk_sectors(ns->queue, rounddown_pow_of_two(iob));
 	nvme_update_disk_info(disk, ns, id);
 #ifdef CONFIG_NVME_MULTIPATH
-- 
2.25.1

