Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8937C97E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhELQTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235875AbhELQLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99CB61D42;
        Wed, 12 May 2021 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834042;
        bh=tqHUNvc8a8XupP10MTLcTLfCepQE+wTuWBqFI5Vme6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmZIARPNs946gjJfQdIDrWwvytb+tnRGbVL+LKiUz8sOjTGqut7aTGuGFMRJtKlho
         Bht7c6oeu9iAth/0OsmpOuEuPFty5DqixkNLdgTqM7nHTkGQVS1zgrfOJMJcP6qzNe
         O0473KJfLRHGNxwE9rxl1D7k3sX7C/BYTDEGzUcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 386/601] ataflop: potential out of bounds in do_format()
Date:   Wed, 12 May 2021 16:47:43 +0200
Message-Id: <20210512144840.505988507@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1ffec389a6431782a8a28805830b6fae9bf00af1 ]

The function uses "type" as an array index:

	q = unit[drive].disk[type]->queue;

Unfortunately the bounds check on "type" isn't done until later in the
function.  Fix this by moving the bounds check to the start.

Fixes: bf9c0538e485 ("ataflop: use a separate gendisk for each media format")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 104b713f4055..aed2c2a4f4ea 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -729,8 +729,12 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	unsigned long	flags;
 	int ret;
 
-	if (type)
+	if (type) {
 		type--;
+		if (type >= NUM_DISK_MINORS ||
+		    minor2disktype[type].drive_types > DriveType)
+			return -EINVAL;
+	}
 
 	q = unit[drive].disk[type]->queue;
 	blk_mq_freeze_queue(q);
@@ -742,11 +746,6 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	local_irq_restore(flags);
 
 	if (type) {
-		if (type >= NUM_DISK_MINORS ||
-		    minor2disktype[type].drive_types > DriveType) {
-			ret = -EINVAL;
-			goto out;
-		}
 		type = minor2disktype[type].index;
 		UDT = &atari_disk_type[type];
 	}
-- 
2.30.2



