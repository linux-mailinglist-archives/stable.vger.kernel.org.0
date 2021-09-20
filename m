Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EE5411F24
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352143AbhITRiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351922AbhITRgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:36:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AA0461555;
        Mon, 20 Sep 2021 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157585;
        bh=18SKgSVfcandKcQgfjEOvlaxnLA9BHY6NckDc9DEQPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNtdRyuC6NVTPjC4xqjmFOlWWVYiZOvNxZdSbVR1Rm+Y8pEnLy2VcqpBasccMJg6K
         lTj7aZylAj97gOjFYqXfndwBBOC6PQFv0g2DxDspNeT2SMBQ1aoD7BPwn4g6/6w/RC
         zcq+2nQzsqwY/6OXOJ1niFd/XqGLxbKOH2Rc34SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phong Hoang <phong.hoang.wz@renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/293] clocksource/drivers/sh_cmt: Fix wrong setting if dont request IRQ for clock source channel
Date:   Mon, 20 Sep 2021 18:40:20 +0200
Message-Id: <20210920163935.241595705@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phong Hoang <phong.hoang.wz@renesas.com>

[ Upstream commit be83c3b6e7b8ff22f72827a613bf6f3aa5afadbb ]

If CMT instance has at least two channels, one channel will be used
as a clock source and another one used as a clock event device.
In that case, IRQ is not requested for clock source channel so
sh_cmt_clock_event_program_verify() might work incorrectly.
Besides, when a channel is only used for clock source, don't need to
re-set the next match_value since it should be maximum timeout as
it still is.

On the other hand, due to no IRQ, total_cycles is not counted up
when reaches compare match time (timer counter resets to zero),
so sh_cmt_clocksource_read() returns unexpected value.
Therefore, use 64-bit clocksoure's mask for 32-bit or 16-bit variants
will also lead to wrong delta calculation. Hence, this mask should
correspond to timer counter width, and above function just returns
the raw value of timer counter register.

Fixes: bfa76bb12f23 ("clocksource: sh_cmt: Request IRQ for clock event device only")
Fixes: 37e7742c55ba ("clocksource/drivers/sh_cmt: Fix clocksource width for 32-bit machines")
Signed-off-by: Phong Hoang <phong.hoang.wz@renesas.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210422123443.73334-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/sh_cmt.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index cec90a4c79b3..7a6d4c4c0feb 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -576,7 +576,8 @@ static int sh_cmt_start(struct sh_cmt_channel *ch, unsigned long flag)
 	ch->flags |= flag;
 
 	/* setup timeout if no clockevent */
-	if ((flag == FLAG_CLOCKSOURCE) && (!(ch->flags & FLAG_CLOCKEVENT)))
+	if (ch->cmt->num_channels == 1 &&
+	    flag == FLAG_CLOCKSOURCE && (!(ch->flags & FLAG_CLOCKEVENT)))
 		__sh_cmt_set_next(ch, ch->max_match_value);
  out:
 	raw_spin_unlock_irqrestore(&ch->lock, flags);
@@ -612,20 +613,25 @@ static struct sh_cmt_channel *cs_to_sh_cmt(struct clocksource *cs)
 static u64 sh_cmt_clocksource_read(struct clocksource *cs)
 {
 	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
-	unsigned long flags;
 	u32 has_wrapped;
-	u64 value;
-	u32 raw;
 
-	raw_spin_lock_irqsave(&ch->lock, flags);
-	value = ch->total_cycles;
-	raw = sh_cmt_get_counter(ch, &has_wrapped);
+	if (ch->cmt->num_channels == 1) {
+		unsigned long flags;
+		u64 value;
+		u32 raw;
 
-	if (unlikely(has_wrapped))
-		raw += ch->match_value + 1;
-	raw_spin_unlock_irqrestore(&ch->lock, flags);
+		raw_spin_lock_irqsave(&ch->lock, flags);
+		value = ch->total_cycles;
+		raw = sh_cmt_get_counter(ch, &has_wrapped);
+
+		if (unlikely(has_wrapped))
+			raw += ch->match_value + 1;
+		raw_spin_unlock_irqrestore(&ch->lock, flags);
+
+		return value + raw;
+	}
 
-	return value + raw;
+	return sh_cmt_get_counter(ch, &has_wrapped);
 }
 
 static int sh_cmt_clocksource_enable(struct clocksource *cs)
@@ -688,7 +694,7 @@ static int sh_cmt_register_clocksource(struct sh_cmt_channel *ch,
 	cs->disable = sh_cmt_clocksource_disable;
 	cs->suspend = sh_cmt_clocksource_suspend;
 	cs->resume = sh_cmt_clocksource_resume;
-	cs->mask = CLOCKSOURCE_MASK(sizeof(u64) * 8);
+	cs->mask = CLOCKSOURCE_MASK(ch->cmt->info->width);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
 	dev_info(&ch->cmt->pdev->dev, "ch%u: used as clock source\n",
-- 
2.30.2



