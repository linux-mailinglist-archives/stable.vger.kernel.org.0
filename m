Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAEE3A9AE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbfFIQ7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbfFIQ7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14804206C3;
        Sun,  9 Jun 2019 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099546;
        bh=NRvK615v25GoOdRPL360NWzr60LSRHxx997j8H+H/mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRHxLhAvXIUOIxJ+/leHOGmXSxQOdvS+lpPIPlphjzGgH1IGoFgyUCUQJR7uR+5jT
         mfAsRAqc1j8vGqGOniWPb03Of9QT3gD1fvf1+a9+Lw1fa6JE76y3lYEJYGA+9+pWSn
         wxPdTa5vc3W0SFOBTzhSFxTl+C9VYNz0LbUydbvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: [PATCH 4.4 078/241] bio: fix improper use of smp_mb__before_atomic()
Date:   Sun,  9 Jun 2019 18:40:20 +0200
Message-Id: <20190609164150.022547203@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
@@ -290,7 +290,7 @@ static inline void bio_cnt_set(struct bi
 {
 	if (count != 1) {
 		bio->bi_flags |= (1 << BIO_REFFED);
-		smp_mb__before_atomic();
+		smp_mb();
 	}
 	atomic_set(&bio->__bi_cnt, count);
 }


