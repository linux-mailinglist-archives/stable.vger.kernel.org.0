Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17EC51070DE
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfKVKho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbfKVKhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:37:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 998AA20708;
        Fri, 22 Nov 2019 10:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419062;
        bh=jRkMy5qS/eVIHEWYR98ab5sYmGj8XzK7xyoKH2bdxUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwQylN7/6iUH70UKpbps7kQLIIl6YhgHFXfdR5Vd8saqx3B68J7n5W1KTO0b6z5bd
         4vvdtGelJxiaQCDSMDapuoXrPnP0k2L1pOw+lEBZII5n0Bad7dPMHd3KX4m5/HodEj
         mhaSWxb6rKPIkc3tMxrDUlyQpz75FVzA5l1Vfez8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 144/159] bcache: recal cached_dev_sectors on detach
Date:   Fri, 22 Nov 2019 11:28:55 +0100
Message-Id: <20191122100839.063462297@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e420921460836..df8f1e69077f6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -902,6 +902,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 	bch_write_bdev_super(dc, &cl);
 	closure_sync(&cl);
 
+	calc_cached_dev_sectors(dc->disk.c);
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
 
-- 
2.20.1



