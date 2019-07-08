Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8451623BC
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfGHPhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:37:37 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:49006 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733152AbfGHPhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 11:37:37 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2019 11:37:36 EDT
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id F27A32E0A47;
        Mon,  8 Jul 2019 18:29:58 +0300 (MSK)
Received: from smtpcorp1p.mail.yandex.net (smtpcorp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:10])
        by mxbackcorp1g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id SGvld7Yg6z-Twtq6Pmt;
        Mon, 08 Jul 2019 18:29:58 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1562599798; bh=0ZLPgrM5RZIP8rfkfWdS2iGaxPtAPBUurmkYWYh9nVw=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=zZVm+LqvUNOElt9D5Fpn62DNu+R6E0Ocf8yo6kaWwidtIpAQSdGKp/OkZzxLJBe+J
         gtdlZnaG0r8g/Cm3GNijyGzyJNsyDCOld478M6SLZArM9/xmFLAlaoZozKfdQt6Vlk
         UHan79Lq3uT+tyIP2BtXXdXM5co4Gn4d4ZGRLyYA=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:fce8:911:2fe8:4dfb])
        by smtpcorp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id 7RpncgZf1J-Tww4iCld;
        Mon, 08 Jul 2019 18:29:58 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH] blk-throttle: fix zero wait time for iops throttled group
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Cc:     Liu Bo <bo.liu@linux.alibaba.com>, stable@vger.kernel.org
Date:   Mon, 08 Jul 2019 18:29:57 +0300
Message-ID: <156259979778.2486.6296077059654653057.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops
limit is enforced") wait time could be zero even if group is throttled and
cannot issue requests right now. As a result throtl_select_dispatch() turns
into busy-loop under irq-safe queue spinlock.

Fix is simple: always round up target time to the next throttle slice.

Fixes: 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops limit is enforced")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: stable@vger.kernel.org # v4.19+
---
 block/blk-throttle.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9ea7c0ecad10..8ab6c8153223 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -881,13 +881,10 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	u64 tmp;
 
-	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
-
-	/* Slice has just started. Consider one slice interval */
-	if (!jiffy_elapsed)
-		jiffy_elapsed_rnd = tg->td->throtl_slice;
+	jiffy_elapsed = jiffies - tg->slice_start[rw];
 
-	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
+	/* Round up to the next throttle slice, wait time must be nonzero */
+	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
 
 	/*
 	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be

