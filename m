Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961422E3B44
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405793AbgL1NsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405761AbgL1Nrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3098C208BA;
        Mon, 28 Dec 2020 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163226;
        bh=rDa+tRso19nOXqK3oypBBItt/qOeQF0e38L5BfD5xm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEoWyptQlvhw9M0R8ww+tDFWe3w8WrSBDqqm3U6Sb+eTTEq+M04kHW/n9S/fC+YLF
         5biWSMXV7EWt6d3p90ri3l/WOlba8vmUaSuMMFrBREnNO6h5RO+xt8XjNFQc9BdJaE
         Ub5WmMWD8iH14qKsFhrnzB22l7mOAI0F3VuamjVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/453] iio: hrtimer-trigger: Mark hrtimer to expire in hard interrupt context
Date:   Mon, 28 Dec 2020 13:47:30 +0100
Message-Id: <20201228124947.517349703@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 0178297c1e6898e2197fe169ef3be723e019b971 ]

On PREEMPT_RT enabled kernels unmarked hrtimers are moved into soft
interrupt expiry mode by default.

The IIO hrtimer-trigger needs to run in hard interrupt context since it
will end up calling generic_handle_irq() which has the requirement to run
in hard interrupt context.

Explicitly specify that the timer needs to run in hard interrupt context by
using the HRTIMER_MODE_REL_HARD flag.

Fixes: f5c2f0215e36 ("hrtimer: Move unmarked hrtimers to soft interrupt expiry on RT")
Reported-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20201117103751.16131-1-lars@metafoo.de
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/trigger/iio-trig-hrtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/trigger/iio-trig-hrtimer.c b/drivers/iio/trigger/iio-trig-hrtimer.c
index a5e670726717f..58c1c30d5612b 100644
--- a/drivers/iio/trigger/iio-trig-hrtimer.c
+++ b/drivers/iio/trigger/iio-trig-hrtimer.c
@@ -102,7 +102,7 @@ static int iio_trig_hrtimer_set_state(struct iio_trigger *trig, bool state)
 
 	if (state)
 		hrtimer_start(&trig_info->timer, trig_info->period,
-			      HRTIMER_MODE_REL);
+			      HRTIMER_MODE_REL_HARD);
 	else
 		hrtimer_cancel(&trig_info->timer);
 
@@ -132,7 +132,7 @@ static struct iio_sw_trigger *iio_trig_hrtimer_probe(const char *name)
 	trig_info->swt.trigger->ops = &iio_hrtimer_trigger_ops;
 	trig_info->swt.trigger->dev.groups = iio_hrtimer_attr_groups;
 
-	hrtimer_init(&trig_info->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init(&trig_info->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
 	trig_info->timer.function = iio_hrtimer_trig_handler;
 
 	trig_info->sampling_frequency = HRTIMER_DEFAULT_SAMPLING_FREQUENCY;
-- 
2.27.0



