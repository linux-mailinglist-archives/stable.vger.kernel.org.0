Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4933F106FD1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfKVLSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729917AbfKVKsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:48:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9714205C9;
        Fri, 22 Nov 2019 10:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419703;
        bh=rIE4VPIrEIPSgI9Tss7jaX/soOHcNIuRa+Zq6z6B5Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFHEH3MUj4Mn1rchZ0z3DrdrqW9tekLMnX+3ChYs2S6svGYZ6CqgA9genQcsEn99k
         QrlJIdTWMi923eX73o9cVJl7/lKSjoMk2hfs2NorZcvgHyA9ePFIwNKii0WDKsvw+w
         H1rVQ2gdjOtZhnI9M49rBTHujxrb+TZIQM7v4Q+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 202/222] bcache: recal cached_dev_sectors on detach
Date:   Fri, 22 Nov 2019 11:29:02 +0100
Message-Id: <20191122100916.847108132@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
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



