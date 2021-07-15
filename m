Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4033CA95D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242387AbhGOTGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241555AbhGOTFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 815DC613D6;
        Thu, 15 Jul 2021 19:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375685;
        bh=c9EGxwS9gjmZCWVO88d9ScpV/GD7O5F8EUpe4LvpiQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlOtMe6CjwR2JdNcir2YA/g6FYnfIp9BTiuA/OhrCecMtWlWPTwSJ1HVelAa/vTt4
         wT/SdBP+X7QBFyDiQjEq+4rZGkI7U7fs7LZYBqIpV5NmfMnU9e9GE9fi1MiCG4QUA1
         6gCRja61KbOzIVHSEZllfdEJbrUoIGSWAlruy0w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.12 191/242] clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround
Date:   Thu, 15 Jul 2021 20:39:13 +0200
Message-Id: <20210715182626.826804514@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
@@ -352,7 +352,7 @@ static u64 notrace arm64_858921_read_cnt
 	do {								\
 		_val = read_sysreg(reg);				\
 		_retries--;						\
-	} while (((_val + 1) & GENMASK(9, 0)) <= 1 && _retries);	\
+	} while (((_val + 1) & GENMASK(8, 0)) <= 1 && _retries);	\
 									\
 	WARN_ON_ONCE(!_retries);					\
 	_val;								\


