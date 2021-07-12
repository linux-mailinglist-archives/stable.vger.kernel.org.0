Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40293C4CA3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242201AbhGLHG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241614AbhGLHEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DA46611AD;
        Mon, 12 Jul 2021 07:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073273;
        bh=Pq4EhHKMvQqR0dTi44tWCX6DB7KbvPxZSq5FW7Mm8F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5P3VjxoXh8yuhKrYgycGVxu3INTAsE5hYheMy1ygRTzqLbIH4WHq8d8EXctHr1Ce
         1e2ZECOLyylt3RqIW7O4nEj8AT6m8o29ppem3sFbOfQmCyR16Z1/1+KylJmYzo5v9g
         fHYNJZJz20UK400gICo3KpnTHdNiKiSZb+92/GPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 168/700] mmc: sdhci-of-aspeed: Turn down a phase correction warning
Date:   Mon, 12 Jul 2021 08:04:11 +0200
Message-Id: <20210712060949.659222662@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit a7ab186f60785850b5af1be183867000485ad491 ]

The card timing and the bus frequency are not changed atomically with
respect to calls to the set_clock() callback in the driver. The result
is the driver sees a transient state where there's a mismatch between
the two and thus the inputs to the phase correction calculation
formula are garbage.

Switch from dev_warn() to dev_dbg() to avoid noise in the normal case,
though the change does make bad configurations less likely to be
noticed.

Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20210607013020.85885-1-andrew@aj.id.au
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-of-aspeed.c b/drivers/mmc/host/sdhci-of-aspeed.c
index 7d8692e90996..b6ac2af199b8 100644
--- a/drivers/mmc/host/sdhci-of-aspeed.c
+++ b/drivers/mmc/host/sdhci-of-aspeed.c
@@ -150,7 +150,7 @@ static int aspeed_sdhci_phase_to_tap(struct device *dev, unsigned long rate_hz,
 
 	tap = div_u64(phase_period_ps, prop_delay_ps);
 	if (tap > ASPEED_SDHCI_NR_TAPS) {
-		dev_warn(dev,
+		dev_dbg(dev,
 			 "Requested out of range phase tap %d for %d degrees of phase compensation at %luHz, clamping to tap %d\n",
 			 tap, phase_deg, rate_hz, ASPEED_SDHCI_NR_TAPS);
 		tap = ASPEED_SDHCI_NR_TAPS;
-- 
2.30.2



