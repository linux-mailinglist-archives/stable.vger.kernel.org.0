Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B23EB7C
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 22:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbfD2UQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 16:16:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35454 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbfD2UQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 16:16:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id f7so9374778wrs.2
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 13:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HnQQB+q10KJ+tBjmTDVhEUeBuplkgzFkaabaWorIDK0=;
        b=V8llIgXP6nhj3mBW9/AXO9OGQRGRnVOgd/Mgx/UqS0Dmg6P71DCInuxWyizpcBDv2v
         s4LWS3ulfKwPBDJxaH97b/cxsArPA7/vK6pLhrgQwPdEmqCASyvUl8VDq6EE/M867QlH
         vuLUSwu+6ZvKtN0hQBgi2CjSm7a1FwV/4h3/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HnQQB+q10KJ+tBjmTDVhEUeBuplkgzFkaabaWorIDK0=;
        b=MCtFjR0/w7tZbH/O/ksA+lG9FsRAZ3JMDYQzzbVGsxh6fMcA2tLp96WN/ZaE2PNSrw
         L0KSLWAIPOLY7NgK08IINOwg0Ku+yZxZ6cHrO4NKHC2uCVjSyMvYFkjm2SCBgkX/NY2p
         uB4XGxnYFeGRm2ycVt4oo14JSSzVGRFDi34NksO3+o6Z99dZyX+5WEdPrf7DbGByg2zB
         pi241AkV5o0NM8kBrbHENy43UeqfML9fGshdq5zcvlV86tnkkIum0nyq1sK/7SOiw2og
         N5lHW5oeKOCJ4VBRO15ZmbKZTP5Y/pSUkIEBB0jRkvLAbl3Stzjjc4Wh3szhOc0IPeJI
         5h2Q==
X-Gm-Message-State: APjAAAWKO1dvWIVTwKvSTGgHQgcJGfAFjwG38p84ShWDD0H64UdXV9KA
        tNM9zBUNxUGjWXFEhkMfxK9wxQ==
X-Google-Smtp-Source: APXvYqzO/shy+lwWyu704q2dOX00yaUvvzyKRtzyAEk5wDzatGiK5EyHB6NgTBNQOz/tIfNcD7NiVw==
X-Received: by 2002:adf:fb4a:: with SMTP id c10mr13358709wrs.309.1556568958675;
        Mon, 29 Apr 2019 13:15:58 -0700 (PDT)
Received: from localhost.localdomain (ip-93-97.sn2.clouditalia.com. [83.211.93.97])
        by smtp.gmail.com with ESMTPSA id k6sm22864019wrd.20.2019.04.29.13.15.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 13:15:57 -0700 (PDT)
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: [PATCH 2/5] bio: fix improper use of smp_mb__before_atomic()
Date:   Mon, 29 Apr 2019 22:14:58 +0200
Message-Id: <1556568902-12464-3-git-send-email-andrea.parri@amarulasolutions.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This barrier only applies to the read-modify-write operations; in
particular, it does not apply to the atomic_set() primitive.

Replace the barrier with an smp_mb().

Fixes: dac56212e8127 ("bio: skip atomic inc/dec of ->bi_cnt for most use cases")
Cc: stable@vger.kernel.org
Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index e584673c18814..5becbafb84e8a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -224,7 +224,7 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
 {
 	if (count != 1) {
 		bio->bi_flags |= (1 << BIO_REFFED);
-		smp_mb__before_atomic();
+		smp_mb();
 	}
 	atomic_set(&bio->__bi_cnt, count);
 }
-- 
2.7.4

