Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCDF1CABB5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgEHMqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729394AbgEHMqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80504208D6;
        Fri,  8 May 2020 12:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941969;
        bh=uKsOAPcBFib9N1+sUWvS/G4lDjap4tXX+B7v6rlVBnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOnR3HSPKhivGLBpHhoiZOlaqUkyfvvUDe5FUcsPl4tCdy89MRUKjvbc5HqURUoQu
         C9lw+glmLeaZmN9oxDZaP2wO5LTKp4MxXPMgApVZEFfeg6FUmfMBZ1sb6AFWQJ4sZD
         HbJ4163LeD3Krqvr/kL8+ep160Ss5vMHeKKc8Vmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meelis Roos <mroos@linux.ee>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 4.4 245/312] blk-mq: fix undefined behaviour in order_to_size()
Date:   Fri,  8 May 2020 14:33:56 +0200
Message-Id: <20200508123141.650923068@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

commit b3a834b1596ac668df206aa2bb1f191c31f5f5e4 upstream.

When this_order variable in blk_mq_init_rq_map() becomes zero
the code incorrectly decrements the variable and passes the result
to order_to_size() helper causing undefined behaviour:

 UBSAN: Undefined behaviour in block/blk-mq.c:1459:27
 shift exponent 4294967295 is too large for 32-bit type 'unsigned int'
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.6.0-rc6-00072-g33656a1 #22

Fix the code by checking this_order variable for not having the zero
value first.

Reported-by: Meelis Roos <mroos@linux.ee>
Fixes: 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism")
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1491,7 +1491,7 @@ static struct blk_mq_tags *blk_mq_init_r
 		int to_do;
 		void *p;
 
-		while (left < order_to_size(this_order - 1) && this_order)
+		while (this_order && left < order_to_size(this_order - 1))
 			this_order--;
 
 		do {


