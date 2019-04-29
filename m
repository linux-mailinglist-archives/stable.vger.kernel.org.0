Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C8FEB7D
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfD2UQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 16:16:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41038 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbfD2UQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 16:16:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id c12so17856705wrt.8
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 13:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Tf7MLbuwm8AwySzke/NOZGkPfHj632yqYUtU8HHCGbc=;
        b=lt2JmU9usNLupk17GENygz8xjZEYXly2t8l41TwQCwNB/wXDK7iOj5DEQUmhzdByfb
         3mdulYuOjhKIMLP7Y1bb6H6JQDVOLvM3JhAdlgWC53GJQUEAFdK0HN122obTyWFcvnzl
         p5eaoNHIlJvKwUhaLPWMn5i8SXw1vHRMH0NLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Tf7MLbuwm8AwySzke/NOZGkPfHj632yqYUtU8HHCGbc=;
        b=qfCZnQ0snoO6MEeYaevm64oq3nkYw66kuqbKZibJjD7/rtYexfpeNQoOLwiaFg2Mwg
         wvDtD3vruVoinUNZXnqVBaau7NGmPZgqaPLdUVc6j9Fqeo/i0qvV6MIKZDEnCfHmzfMu
         bGCFfx7vFDoJfizo4RVeIMgK46Hy+5WpJVcwB7EyuOsgFA4WlglNwfLa7OpRQdknT1kF
         kWgoeWJCgVsgwUg5rU4czAG7dR6YOwdDb8ul21oUhj4JJ4zFFsSCoDUQtzBXQccn39MB
         DoN8gnbWGRRO5CgfgblitT5crvPqh75hH1xIdzgreYIfFWK86alji3D4et36uOb+5I5A
         4aFw==
X-Gm-Message-State: APjAAAU5fZ5pOkWz4+wRX84zVkT5e54566enC2OjUwrT2xMdRHk4pys4
        MNmgyDhtf3LdDeDaSff8fu/ZGg==
X-Google-Smtp-Source: APXvYqxCWUtW1QCMY+cBeSIXhZF4eeOqHKw9FHvYl2dBn2UjRBtO2Cz5wDL0aGxLp6V2/9d/+3rzKQ==
X-Received: by 2002:adf:df92:: with SMTP id z18mr6962697wrl.213.1556568961502;
        Mon, 29 Apr 2019 13:16:01 -0700 (PDT)
Received: from localhost.localdomain (ip-93-97.sn2.clouditalia.com. [83.211.93.97])
        by smtp.gmail.com with ESMTPSA id k6sm22864019wrd.20.2019.04.29.13.16.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 13:16:00 -0700 (PDT)
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org
Subject: [PATCH 3/5] sbitmap: fix improper use of smp_mb__before_atomic()
Date:   Mon, 29 Apr 2019 22:14:59 +0200
Message-Id: <1556568902-12464-4-git-send-email-andrea.parri@amarulasolutions.com>
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

Fixes: 6c0ca7ae292ad ("sbitmap: fix wakeup hang after sbq resize")
Cc: stable@vger.kernel.org
Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Omar Sandoval <osandov@fb.com>
Cc: linux-block@vger.kernel.org
---
 lib/sbitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 155fe38756ecf..4a7fc4915dfc6 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -435,7 +435,7 @@ static void sbitmap_queue_update_wake_batch(struct sbitmap_queue *sbq,
 		 * to ensure that the batch size is updated before the wait
 		 * counts.
 		 */
-		smp_mb__before_atomic();
+		smp_mb();
 		for (i = 0; i < SBQ_WAIT_QUEUES; i++)
 			atomic_set(&sbq->ws[i].wait_cnt, 1);
 	}
-- 
2.7.4

