Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790317467E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404220AbfGYFjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404214AbfGYFjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:39:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FFA022BEF;
        Thu, 25 Jul 2019 05:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033194;
        bh=WO7lM+upPBvUtwOll1Wkav1Vka6e95b0zA6c7vFYhfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xrlcp4TWiyzfAxlYCE1s4Y/HSsmMWmY2OmpCrp7JaJwjMci55MUHjkJ9TRkJDrfDO
         4DE6rE2Kwg9uiPsoTESYl99FrydIDM5gKRntaVujfaOfilxcOTUozJUxdrnijVJs5x
         QLTh8UJQsaoNShJtOyToepZhYKzs8YjA8L8qwGEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/271] blk-iolatency: only account submitted bios
Date:   Wed, 24 Jul 2019 21:19:13 +0200
Message-Id: <20190724191702.387111366@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
index 6b8396ccb5c4..75df47ad2e79 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -565,6 +565,10 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	if (!blkg)
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



