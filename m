Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50D233B9A3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhCOOGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233450AbhCOOBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F96164F10;
        Mon, 15 Mar 2021 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816889;
        bh=HdP+5+/BeRS/KqbN7ECQPN4VR2LtCf/q1WvQ07E02j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=146wnL7MsStE7GzpjstZeHk1jwB8EICABsdUw9KwtkohxE9KW+jYmZGywzXqarqbM
         rBltAfWu1Pn09TB0eQRRYLbmwWd47FMLX6mwoBUCdnC7C21y3tcRic9niMGTjQH523
         BwscQt13drRVdNScKu8W8dWBd/AzTz56FYmqZw40=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 184/306] s390/dasd: fix hanging IO request during DASD driver unbind
Date:   Mon, 15 Mar 2021 14:54:07 +0100
Message-Id: <20210315135513.836735326@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
@@ -3068,7 +3068,8 @@ static blk_status_t do_dasd_request(stru
 
 	basedev = block->base;
 	spin_lock_irq(&dq->lock);
-	if (basedev->state < DASD_STATE_READY) {
+	if (basedev->state < DASD_STATE_READY ||
+	    test_bit(DASD_FLAG_OFFLINE, &basedev->flags)) {
 		DBF_DEV_EVENT(DBF_ERR, basedev,
 			      "device not ready for request %p", req);
 		rc = BLK_STS_IOERR;


