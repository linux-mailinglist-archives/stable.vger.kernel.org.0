Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1433E2C075E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732437AbgKWMkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732443AbgKWMkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B71272065E;
        Mon, 23 Nov 2020 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135217;
        bh=jUczGZaOyp/m3vsYvk078BiNvDE7dEuLLgs0SyTViYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGiDWMOI8XTUZxOh30HoJHsxk706c5lOyStRs89SnE5X1HRvLPNoogPMWyCuuaYLK
         QX+wSu1IlusgIbof/OTqL2938wYvGsYRXn0Or6rwHKyTrbC2if05iPjCvc99KhdTlE
         5vIVociuw9X2gBiyYKK+tvLPBr6XRluvSnqgeVw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 147/158] s390/dasd: fix null pointer dereference for ERP requests
Date:   Mon, 23 Nov 2020 13:22:55 +0100
Message-Id: <20201123121827.019690026@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 6f117cb854a44a79898d844e6ae3fd23bd94e786 upstream.

When requeueing all requests on the device request queue to the blocklayer
we might get to an ERP (error recovery) request that is a copy of an
original CQR.

Those requests do not have blocklayer request information or a pointer to
the dasd_queue set. When trying to access those data it will lead to a
null pointer dereference in dasd_requeue_all_requests().

Fix by checking if the request is an ERP request that can simply be
ignored. The blocklayer request will be requeued by the original CQR that
is on the device queue right behind the ERP request.

Fixes: 9487cfd3430d ("s390/dasd: fix handling of internal requests")
Cc: <stable@vger.kernel.org> #4.16
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2980,6 +2980,12 @@ static int _dasd_requeue_request(struct
 
 	if (!block)
 		return -EINVAL;
+	/*
+	 * If the request is an ERP request there is nothing to requeue.
+	 * This will be done with the remaining original request.
+	 */
+	if (cqr->refers)
+		return 0;
 	spin_lock_irq(&cqr->dq->lock);
 	req = (struct request *) cqr->callback_data;
 	blk_mq_requeue_request(req, false);


