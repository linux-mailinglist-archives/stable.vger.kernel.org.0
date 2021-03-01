Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286673290FD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhCAUSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242743AbhCAUIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:08:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A9764F69;
        Mon,  1 Mar 2021 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621581;
        bh=MFV1TSpw4E9ecp7/2VH+UKvVrU4GAmXOl9XIDe5bUlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJocPDYStX5+u9jYODtumPOZkHoKdZTC2luSY3SUDMRgnkLwCoMjfo1l4dD912/qI
         sO/ih2Ztxw6K0VvMr5jCiKpZ0I6RV7V30JfJ0phR+OHnnY4R8dKEXhENDqt+msD+GH
         v5ExrWPv9RtPMgjgcQ0A7ERKYvMdvK60Ta+2dE5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 569/775] block: fix logging on capacity change
Date:   Mon,  1 Mar 2021 17:12:17 +0100
Message-Id: <20210301161229.580651660@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 452c0bf8754fbeffdf579465b82a3c2bbe373c95 ]

Local variable of 'capacity' stores the previous disk capacity, and
'size' variable records the latest disk capacity, so swap them for
fixing logging on capacity change.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: a782483cc1f8 ("block: remove the nr_sects field in struct hd_struct")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9e741a4f351be..07a0ef741de19 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -74,7 +74,7 @@ bool set_capacity_and_notify(struct gendisk *disk, sector_t size)
 		return false;
 
 	pr_info("%s: detected capacity change from %lld to %lld\n",
-		disk->disk_name, size, capacity);
+		disk->disk_name, capacity, size);
 
 	/*
 	 * Historically we did not send a uevent for changes to/from an empty
-- 
2.27.0



