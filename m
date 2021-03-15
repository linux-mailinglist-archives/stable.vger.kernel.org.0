Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274CF33B819
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhCOOCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232884AbhCOOAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D00BB64F5E;
        Mon, 15 Mar 2021 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816787;
        bh=foAQqbn99H8ZvIr8aDDOBpEBQF6iFeotkCTkcixB7k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+SG06ti3KkmiRYGkHLoXnhgQm7bEgYFM3EBzjKNsI55WViF3ObiBTn5PTmR/PE6i
         wZb0REiZ1H2nxt01TpioZfE9sdg3C0lkKKiHuHgfS2SYcLWc4PMWkIBwvtYSCqNdai
         3JGYUcKPKdXIPVzoj9Lm1g2vY1loFmnuRlMGBc6M=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 067/120] s390/dasd: fix hanging IO request during DASD driver unbind
Date:   Mon, 15 Mar 2021 14:56:58 +0100
Message-Id: <20210315135722.167047466@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Stefan Haberland <sth@linux.ibm.com>

commit 66f669a272898feb1c69b770e1504aa2ec7723d1 upstream.

Prevent that an IO request is build during device shutdown initiated by
a driver unbind. This request will never be able to be processed or
canceled and will hang forever. This will lead also to a hanging unbind.

Fix by checking not only if the device is in READY state but also check
that there is no device offline initiated before building a new IO request.

Fixes: e443343e509a ("s390/dasd: blk-mq conversion")

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Tested-by: Bjoern Walk <bwalk@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2940,7 +2940,8 @@ static blk_status_t do_dasd_request(stru
 
 	basedev = block->base;
 	spin_lock_irq(&dq->lock);
-	if (basedev->state < DASD_STATE_READY) {
+	if (basedev->state < DASD_STATE_READY ||
+	    test_bit(DASD_FLAG_OFFLINE, &basedev->flags)) {
 		DBF_DEV_EVENT(DBF_ERR, basedev,
 			      "device not ready for request %p", req);
 		rc = BLK_STS_IOERR;


