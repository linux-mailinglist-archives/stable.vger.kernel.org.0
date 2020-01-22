Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23D514562F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgAVNVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbgAVNVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:21:54 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0474C2467C;
        Wed, 22 Jan 2020 13:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699313;
        bh=pLeF0alBcThh37xBzLw7dVki1tgMbE2L/olH00haWf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4Izd10p9XjH29Rd+/EhVUavam7sJy5IHilvW84RUr/YHTTUYRhzFIib2xBZ+/eEi
         BF/77HYx0ODl4a5irPP6BNyKmknnct0inFUxQc2RpVcFVmZq04cXDPG3JRTE6mAlR3
         4weAutaEQ1rO4/R1kV35chAeioGH1JGLPaSNj6/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 105/222] block: Fix the type of sts in bsg_queue_rq()
Date:   Wed, 22 Jan 2020 10:28:11 +0100
Message-Id: <20200122092841.257085936@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit c44a4edb20938c85b64a256661443039f5bffdea upstream.

This patch fixes the following sparse warnings:

block/bsg-lib.c:269:19: warning: incorrect type in initializer (different base types)
block/bsg-lib.c:269:19:    expected int sts
block/bsg-lib.c:269:19:    got restricted blk_status_t [usertype]
block/bsg-lib.c:286:16: warning: incorrect type in return expression (different base types)
block/bsg-lib.c:286:16:    expected restricted blk_status_t
block/bsg-lib.c:286:16:    got int [assigned] sts

Cc: Martin Wilck <mwilck@suse.com>
Fixes: d46fe2cb2dce ("block: drop device references in bsg_queue_rq()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bsg-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -266,7 +266,7 @@ static blk_status_t bsg_queue_rq(struct
 	struct request *req = bd->rq;
 	struct bsg_set *bset =
 		container_of(q->tag_set, struct bsg_set, tag_set);
-	int sts = BLK_STS_IOERR;
+	blk_status_t sts = BLK_STS_IOERR;
 	int ret;
 
 	blk_mq_start_request(req);


