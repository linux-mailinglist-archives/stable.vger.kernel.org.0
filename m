Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9144FFA20B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbfKMCBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729747AbfKMCA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1384B22467;
        Wed, 13 Nov 2019 02:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610458;
        bh=rIE4VPIrEIPSgI9Tss7jaX/soOHcNIuRa+Zq6z6B5Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E37Da7sWOf3Upnp4oyte/10hB56nuANquvPy5Iv/UITAgxddCVuTmN4kgAY7/Iu9b
         MuOZgkfh3INxw+RwXDXFhvOw9IjoNqR2axc6MJZ7/Z4LDSXNjqa9yQuSMhn9QNppZ4
         luSV8i4TSSnIHA6iBe6yUyDxuVJeJqWMAlze/Kwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shenghui Wang <shhuiw@foxmail.com>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 49/68] bcache: recal cached_dev_sectors on detach
Date:   Tue, 12 Nov 2019 20:59:13 -0500
Message-Id: <20191113015932.12655-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 46010141da6677b81cc77f9b47f8ac62bd1cbfd3 ]

Recal cached_dev_sectors on cached_dev detached, as recal done on
cached_dev attached.

Update the cached_dev_sectors before bcache_device_detach called
as bcache_device_detach will set bcache_device->c to NULL.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c5bc3e5e921e4..080f9afcde8da 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -904,6 +904,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 	bch_write_bdev_super(dc, &cl);
 	closure_sync(&cl);
 
+	calc_cached_dev_sectors(dc->disk.c);
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
 
-- 
2.20.1

