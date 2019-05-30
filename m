Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2E32F194
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfE3EOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbfE3DQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:13 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C952449A;
        Thu, 30 May 2019 03:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186173;
        bh=Ysv2PzbbJsEvju4N7o/L7/38TGdOq5lM4hxD3RTj5H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvejg9RO7moRctGMcQYeeZcLa5fXJFvypeeaB43YUaNhGjPuovQaSixdaViVjlfQs
         VWvOCpgADorGG+pA+0I4AFR72s4qSVWR1B9jAemgY/MsrKE2/4MOWxxE9kNjWDL/ie
         pAe0nnYxEtfc709B5xFdx6q8QHRrUI+53PYi1HWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: [PATCH 4.19 006/276] bio: fix improper use of smp_mb__before_atomic()
Date:   Wed, 29 May 2019 20:02:44 -0700
Message-Id: <20190530030523.764119003@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri <andrea.parri@amarulasolutions.com>

commit f381c6a4bd0ae0fde2d6340f1b9bb0f58d915de6 upstream.

This barrier only applies to the read-modify-write operations; in
particular, it does not apply to the atomic_set() primitive.

Replace the barrier with an smp_mb().

Fixes: dac56212e8127 ("bio: skip atomic inc/dec of ->bi_cnt for most use cases")
Cc: stable@vger.kernel.org
Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -257,7 +257,7 @@ static inline void bio_cnt_set(struct bi
 {
 	if (count != 1) {
 		bio->bi_flags |= (1 << BIO_REFFED);
-		smp_mb__before_atomic();
+		smp_mb();
 	}
 	atomic_set(&bio->__bi_cnt, count);
 }


