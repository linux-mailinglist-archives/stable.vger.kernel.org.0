Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE2247ABFF
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhLTOki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhLTOjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E318C06139A;
        Mon, 20 Dec 2021 06:39:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB1D4B80EE2;
        Mon, 20 Dec 2021 14:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30366C36AE8;
        Mon, 20 Dec 2021 14:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011173;
        bh=V/PhL0HrcMjn0WYULC30BkQhjL79qXLIbw7re57jW58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0nCkpgJedz49S+LfeUdxe2LGmygSjK9biyiIzrZpxZ2Sfz+NHd0I0/nJH1JW/y56
         dFtjfS2aN5teVtxqpuR5tU+Lb5ghRMPn6e/UpOUcO6ZofJybp6hNDlHOOg8OZ+NNF0
         JsV7TpTwEw4ClxwcF1M/w4MM5Po5JnuIP2CqI59M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Liao <liaoyu15@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 29/45] timekeeping: Really make sure wall_to_monotonic isnt positive
Date:   Mon, 20 Dec 2021 15:34:24 +0100
Message-Id: <20211220143023.247655938@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Liao <liaoyu15@huawei.com>

commit 4e8c11b6b3f0b6a283e898344f154641eda94266 upstream.

Even after commit e1d7ba873555 ("time: Always make sure wall_to_monotonic
isn't positive") it is still possible to make wall_to_monotonic positive
by running the following code:

    int main(void)
    {
        struct timespec time;

        clock_gettime(CLOCK_MONOTONIC, &time);
        time.tv_nsec = 0;
        clock_settime(CLOCK_REALTIME, &time);
        return 0;
    }

The reason is that the second parameter of timespec64_compare(), ts_delta,
may be unnormalized because the delta is calculated with an open coded
substraction which causes the comparison of tv_sec to yield the wrong
result:

  wall_to_monotonic = { .tv_sec = -10, .tv_nsec =  900000000 }
  ts_delta 	    = { .tv_sec =  -9, .tv_nsec = -900000000 }

That makes timespec64_compare() claim that wall_to_monotonic < ts_delta,
but actually the result should be wall_to_monotonic > ts_delta.

After normalization, the result of timespec64_compare() is correct because
the tv_sec comparison is not longer misleading:

  wall_to_monotonic = { .tv_sec = -10, .tv_nsec =  900000000 }
  ts_delta 	    = { .tv_sec = -10, .tv_nsec =  100000000 }

Use timespec64_sub() to ensure that ts_delta is normalized, which fixes the
issue.

Fixes: e1d7ba873555 ("time: Always make sure wall_to_monotonic isn't positive")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211213135727.1656662-1-liaoyu15@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1235,8 +1235,7 @@ int do_settimeofday64(const struct times
 	timekeeping_forward_now(tk);
 
 	xt = tk_xtime(tk);
-	ts_delta.tv_sec = ts->tv_sec - xt.tv_sec;
-	ts_delta.tv_nsec = ts->tv_nsec - xt.tv_nsec;
+	ts_delta = timespec64_sub(*ts, xt);
 
 	if (timespec64_compare(&tk->wall_to_monotonic, &ts_delta) > 0) {
 		ret = -EINVAL;


