Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35248D24E3
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389784AbfJJIve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388982AbfJJIvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:51:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4E4821A4C;
        Thu, 10 Oct 2019 08:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697493;
        bh=PoeGBFpgAmOsUnbpSmyCjPfHcSzenK822ClBtZqhFmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUTjtmUPyFTF0QkHcspp8vhbLVlwhC6kfLN8iAPdYoioS9y2RgDTno3mIDcwACg41
         2zp0FYCwPe5c9opPs4WxCPthrHXILBSmzkspuGxqeuq5zDgGDAyrkhlpmKn13Wu6P7
         0ELrzMdH1IbgnvW+Wnz8k+hCoGl2qb8B6FAAxvPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Melnic <dmm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 47/61] block/ndb: add WQ_UNBOUND to the knbd-recv workqueue
Date:   Thu, 10 Oct 2019 10:37:12 +0200
Message-Id: <20191010083519.494734361@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Melnic <dmm@fb.com>

[ Upstream commit 2189c97cdbed630d5971ab22f05dc998774e354e ]

Add WQ_UNBOUND to the knbd-recv workqueue so we're not bound
to a single CPU that is selected at device creation time.

Signed-off-by: Dan Melnic <dmm@fb.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a65e4ed6c9372..14b491c5cf7b6 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2217,7 +2217,8 @@ static int __init nbd_init(void)
 	if (nbds_max > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 	recv_workqueue = alloc_workqueue("knbd-recv",
-					 WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+					 WQ_MEM_RECLAIM | WQ_HIGHPRI |
+					 WQ_UNBOUND, 0);
 	if (!recv_workqueue)
 		return -ENOMEM;
 
-- 
2.20.1



