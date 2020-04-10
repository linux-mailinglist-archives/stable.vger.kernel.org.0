Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C681A40A3
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgDJD4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgDJDt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDEAD21473;
        Fri, 10 Apr 2020 03:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490567;
        bh=rcjh3l3DjFWYTa13HVk4wQSTUrOgmQ2s6RvdNQnB9Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBl1ezq/R6KgTx+XmOQMjQj2X8kCrpzrZWX51oKOb2qxsFJihyCtHnqYFJIMEls9X
         93hZGGkaVQ9gI+kWAH35Fm9rLOUIn8S4HpMVNu4ZCguZ/iLIkllLcoVa2g4hIrHg6a
         6AOmXcoHOMDYMLgpCF2jTiv86O9I1dB89NSsGTeo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Bob Liu <bob.liu@oracle.com>, Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/46] block: keep bdi->io_pages in sync with max_sectors_kb for stacked devices
Date:   Thu,  9 Apr 2020 23:48:37 -0400
Message-Id: <20200410034909.8922-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit e74d93e96d721c4297f2a900ad0191890d2fc2b0 ]

Field bdi->io_pages added in commit 9491ae4aade6 ("mm: don't cap request
size based on read-ahead setting") removes unneeded split of read requests.

Stacked drivers do not call blk_queue_max_hw_sectors(). Instead they set
limits of their devices by blk_set_stacking_limits() + disk_stack_limits().
Field bio->io_pages stays zero until user set max_sectors_kb via sysfs.

This patch updates io_pages after merging limits in disk_stack_limits().

Commit c6d6e9b0f6b4 ("dm: do not allow readahead to limit IO size") fixed
the same problem for device-mapper devices, this one fixes MD RAIDs.

Fixes: 9491ae4aade6 ("mm: don't cap request size based on read-ahead setting")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8eda2e7b91e4..be1dca0103a45 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -664,6 +664,9 @@ void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 		printk(KERN_NOTICE "%s: Warning: Device %s is misaligned\n",
 		       top, bottom);
 	}
+
+	t->backing_dev_info->io_pages =
+		t->limits.max_sectors >> (PAGE_SHIFT - 9);
 }
 EXPORT_SYMBOL(disk_stack_limits);
 
-- 
2.20.1

