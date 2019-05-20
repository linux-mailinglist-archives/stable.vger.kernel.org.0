Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470B723E6D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 19:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392876AbfETRYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 13:24:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53801 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392873AbfETRYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 13:24:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id 198so163133wme.3
        for <stable@vger.kernel.org>; Mon, 20 May 2019 10:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8JCGP2keOd1v4ZtvnJIPJLCc79LDgGj6QPJ6XqW4/pQ=;
        b=i+tc6wIoCAm8Fs2rzTAE6lyMnY10bwE3S7lTIkqJZ4wLp9lZCEZJRBRsM8BrFytdhh
         LhMP4NBM+t13gVQ+nr5MAL77FdB/RHw847SxYmWgnsV5G8YzL+7g9ryybdRAXx6qXTBL
         Zx0oYhcnH36ZwuiC+JJg0EMqU8kNiHG7ukSDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8JCGP2keOd1v4ZtvnJIPJLCc79LDgGj6QPJ6XqW4/pQ=;
        b=E9tV0ljdu3sZY3KxonevAkwNbjLWjU54NDZmpHlSI/eiTUMDSoslGNxXcomqkShk1v
         JkwrbIIFS6hWOBLm3m+17Hy0XU9K/in5ulDqNeH71St096QPtzjnwKcwideoy2gs8edY
         S9o2Ilj7ZTMVElVQbERFVXmv8OEjC64y9jNi8ig7vAH9jmHyQhaCOLjGoIv2jwX4ooQA
         iAloKC5l+jDZma+lj1+eZu2JvnY3DXOeWKVp/0jNuoS5xGppcCLr9m2GbVlErqywRP71
         r3QDLFj9RDxXDg9DyqwWuIvyXF5cug88uaOjXdmSWSp74ljyHUJ/hMjSLC8tPJKlAEgO
         2+2g==
X-Gm-Message-State: APjAAAVt/2hideUUCEkUlRpEcUupXJM5b9b1Hnj/2teF2mBrWOLEPhmc
        5BeR5GyUh7twIWehszNVLEWj671H1P8OeA==
X-Google-Smtp-Source: APXvYqxgeV4LGEt7Jk6ZUdmwfJ/W+F8V+ZdFAtR5wPJjhjlfgOX2onUnuiC23YystDlcOv8EoDDY4Q==
X-Received: by 2002:a1c:f50a:: with SMTP id t10mr185633wmh.86.1558373080090;
        Mon, 20 May 2019 10:24:40 -0700 (PDT)
Received: from localhost.localdomain ([91.253.179.221])
        by smtp.gmail.com with ESMTPSA id b12sm180021wmg.27.2019.05.20.10.24.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 10:24:39 -0700 (PDT)
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/4] bio: fix improper use of smp_mb__before_atomic()
Date:   Mon, 20 May 2019 19:23:56 +0200
Message-Id: <1558373038-5611-3-git-send-email-andrea.parri@amarulasolutions.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558373038-5611-1-git-send-email-andrea.parri@amarulasolutions.com>
References: <1558373038-5611-1-git-send-email-andrea.parri@amarulasolutions.com>
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
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index ea73df36529ad..0f23b56826403 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -210,7 +210,7 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
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

