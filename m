Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831671BC60
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 19:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbfEMR4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 13:56:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37614 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731961AbfEMR4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 13:56:09 -0400
Received: by mail-io1-f66.google.com with SMTP id u2so9648768ioc.4
        for <stable@vger.kernel.org>; Mon, 13 May 2019 10:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4CcdC3vdWD2Ui0Aq/H7gzZ1C57rvc/Ii4BGhP7cjj0=;
        b=jGDNIPu60fcw0f1WOvGi2tiKVlqgSg6Fb/ykouk/D0JwoTi++nbdU6LgpBsSRtkySy
         4lRd4qsd9DOHTnqJqxcNk6a5pTsQ00tkar43dO1wkrNPX8qlyLdVF6AvEh5z41HyZoJI
         Pok4kVtpBr4M4GRyNifnkmEg2fAZxeJgyDt4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4CcdC3vdWD2Ui0Aq/H7gzZ1C57rvc/Ii4BGhP7cjj0=;
        b=FigtEbeAfFQGf4/NSlz+2MTD3gyNsg4vUHPXRK1MkgTIbmmJowbhABW2hy0BirqeNx
         4tQFqA82PLDpZAPoWRyVHQ1wPXTFlwShJzaXjVLPEpmAOSvZBOa9R8fv+DlF8w54pq/r
         n6d/eFPssUjLcRf/LsfpCTtsXdLpe3+LmCsGvHIhg940IXpx0oh/hTv/HmmcCWFfDstS
         NTHmn/nSOs+1Oc8Ko9Gy1rRfEiH+K19QMiu0yExvikhGjUOkPpM02bdkAu8drBZiEyLD
         Dn9osf6nlZKngWHYKdJJYnIR6DlQmPeUejGbiOqbxI3cNFtTqapTr5ZSnBwUi6/uuOQ8
         l2VQ==
X-Gm-Message-State: APjAAAVYXT0pJxxrgBQjbpJfJAzvfAr2YuwLRV+wG8IwLit77aBd+YRz
        /xy/gyRF4TOgkljaAuttxtsbEjSviVk=
X-Google-Smtp-Source: APXvYqzAf+DYtvpVdAY20sTIyvRr5z31svR51Zlph4CBmXYtO25zPoTjHPP0ujCD+kCxytw8tX9ufA==
X-Received: by 2002:a05:6602:211a:: with SMTP id x26mr15415876iox.202.1557770168407;
        Mon, 13 May 2019 10:56:08 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id l13sm88548iti.6.2019.05.13.10.56.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 10:56:08 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, djkurtz@google.com,
        adrian.hunter@intel.com, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [stable/4.14.y PATCH 2/3] mmc: Fix null pointer dereference in mmc_init_request
Date:   Mon, 13 May 2019 11:55:20 -0600
Message-Id: <20190513175521.84955-3-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190513175521.84955-1-rrangel@chromium.org>
References: <20190513175521.84955-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is possible for queuedata to be cleared in mmc_cleanup_queue before
the request has been started. This will result in dereferencing a null
pointer.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/core/queue.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index d99fa4e63033c..bd7d521d5ad9d 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -159,8 +159,14 @@ static int mmc_init_request(struct request_queue *q, struct request *req,
 {
 	struct mmc_queue_req *mq_rq = req_to_mmc_queue_req(req);
 	struct mmc_queue *mq = q->queuedata;
-	struct mmc_card *card = mq->card;
-	struct mmc_host *host = card->host;
+	struct mmc_card *card;
+	struct mmc_host *host;
+
+	if (!mq)
+		return -ENODEV;
+
+	card = mq->card;
+	host = card->host;
 
 	mq_rq->sg = mmc_alloc_sg(host->max_segs, gfp);
 	if (!mq_rq->sg)
-- 
2.21.0.1020.gf2820cf01a-goog

