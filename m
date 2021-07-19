Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333383CDE70
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344970AbhGSPDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344368AbhGSPBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0AB4601FD;
        Mon, 19 Jul 2021 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709301;
        bh=QbXr4Mo5aHThvqcQbRCuuhMbvaXsNYLB+PbQm/ep94c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8imd8Ab1cGnJLQ6cGjuXjmWkfgorAdoj6IeNEdhTTBGKvcFXWUcm6FwZb69wmduM
         cAsBF6qu6mOrhonCSSVJiS4Sa3BqoNGlXjaMI27TO3AuNOC1uligAMxOebr+dJAKaY
         /F2hmdRvOk82zrW8ThhMvjfXD9wHf43VSE7ZFyUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 4.19 295/421] clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround
Date:   Mon, 19 Jul 2021 16:51:46 +0200
Message-Id: <20210719144956.551398440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit 8b33dfe0ba1c84c1aab2456590b38195837f1e6e upstream.

Bad counter reads are experienced sometimes when bit 10 or greater rolls
over. Originally, testing showed that at least 10 lower bits would be
set to the same value during these bad reads. However, some users still
reported time skips.

Wider testing revealed that on some chips, occasionally only the lowest
9 bits would read as the anomalous value. During these reads (which
still happen only when bit 10), bit 9 would read as the correct value.

Reduce the mask by one bit to cover these cases as well.

Cc: stable@vger.kernel.org
Fixes: c950ca8c35ee ("clocksource/drivers/arch_timer: Workaround for Allwinner A64 timer instability")
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210515021439.55316-1-samuel@sholland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/arm_arch_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -334,7 +334,7 @@ static u64 notrace arm64_858921_read_cnt
 	do {								\
 		_val = read_sysreg(reg);				\
 		_retries--;						\
-	} while (((_val + 1) & GENMASK(9, 0)) <= 1 && _retries);	\
+	} while (((_val + 1) & GENMASK(8, 0)) <= 1 && _retries);	\
 									\
 	WARN_ON_ONCE(!_retries);					\
 	_val;								\


