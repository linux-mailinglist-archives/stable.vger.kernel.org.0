Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0109773B7E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405261AbfGXUAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392090AbfGXUAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B4D20665;
        Wed, 24 Jul 2019 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998435;
        bh=gG5VG+XTA+OvFdThQtGJX+ybh7CaLGuD16nQ0MQYCwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiteBe3EsEqj8HSo3EBzZ8ot7srsuFnzA6OUFNPqROy0YnE8nee1C6K80iOKGS72b
         AgdZATnkATteNodVc6LMnEjKYl0wyuLx3IzTjN+GoNysDe6J0E2FIMjJhQupOPosgy
         TbN4Ihf6qtUinI3lvqKwAakfqFCiKrAFj2Kk9JLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 364/371] blk-throttle: fix zero wait time for iops throttled group
Date:   Wed, 24 Jul 2019 21:21:56 +0200
Message-Id: <20190724191751.569452425@linuxfoundation.org>
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

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit 3a10f999ffd464d01c5a05592a15470a3c4bbc36 upstream.

After commit 991f61fe7e1d ("Blk-throttle: reduce tail io latency when
iops limit is enforced") wait time could be zero even if group is
throttled and cannot issue requests right now. As a result
throtl_select_dispatch() turns into busy-loop under irq-safe queue
spinlock.

Fix is simple: always round up target time to the next throttle slice.

Fixes: 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops limit is enforced")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-throttle.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -881,13 +881,10 @@ static bool tg_with_in_iops_limit(struct
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	u64 tmp;
 
-	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
+	jiffy_elapsed = jiffies - tg->slice_start[rw];
 
-	/* Slice has just started. Consider one slice interval */
-	if (!jiffy_elapsed)
-		jiffy_elapsed_rnd = tg->td->throtl_slice;
-
-	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
+	/* Round up to the next throttle slice, wait time must be nonzero */
+	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
 
 	/*
 	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be


