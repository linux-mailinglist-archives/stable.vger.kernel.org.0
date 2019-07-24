Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8706573DA2
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391080AbfGXTse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391408AbfGXTsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:48:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4AB222ADF;
        Wed, 24 Jul 2019 19:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997713;
        bh=5o0+FHKNLclt1jw24jPprmRdPtsvd4/Gd8oTshsax9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MT9vUoiOcwIzohAGQFc7UV6DlhII8fUwmxwL7SNBEAXemdUuw/pzxUif7cTfrsmWQ
         68PD8mSrzOe8XS7Nu3hB5gXgDHwVFVcNBKd1JnnpFxK+eAVH/YBzj30q1UFySKeQIX
         gyz/duF1p6/Fb4nghxaerU5lMSbHX1ei/+I0Ec/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 115/371] blk-iolatency: only account submitted bios
Date:   Wed, 24 Jul 2019 21:17:47 +0200
Message-Id: <20190724191733.467582391@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a3fb01ba5af066521f3f3421839e501bb2c71805 ]

As is, iolatency recognizes done_bio and cleanup as ending paths. If a
request is marked REQ_NOWAIT and fails to get a request, the bio is
cleaned up via rq_qos_cleanup() and ended in bio_wouldblock_error().
This results in underflowing the inflight counter. Fix this by only
accounting bios that were actually submitted.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 507212d75ee2..58bac44ba78a 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -599,6 +599,10 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
 		return;
 
+	/* We didn't actually submit this bio, don't account it. */
+	if (bio->bi_status == BLK_STS_AGAIN)
+		return;
+
 	iolat = blkg_to_lat(bio->bi_blkg);
 	if (!iolat)
 		return;
-- 
2.20.1



