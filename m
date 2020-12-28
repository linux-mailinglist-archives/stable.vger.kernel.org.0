Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA72E4284
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436490AbgL1N7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407630AbgL1N7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE36D206E5;
        Mon, 28 Dec 2020 13:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163921;
        bh=B5J800G+Ltpx3J0hBV8/H2HsXXdlw+5y1GlVpDnbf1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ov9VNudQLngNk1aHtQQvDB3tPCS4CxQ3oKJuhpZ5L3iTMBebWokxK+rQTHD4jvR2P
         76lyhQqF9EEUhWoNDo137m07sUm8Nw9u+ngLLMz6FvP/PnyBhVHiu/dE4bXgHFcrxB
         V1Gyj4y/jjLLLys/yV9b6eY7IZR70vH77fpakz+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 439/453] clk: tegra: Do not return 0 on failure
Date:   Mon, 28 Dec 2020 13:51:15 +0100
Message-Id: <20201228124958.347682302@linuxfoundation.org>
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

From: Nicolin Chen <nicoleotsuka@gmail.com>

commit 6160aca443148416994c022a35c77daeba948ea6 upstream.

Return values from read_dt_param() will be either TRUE (1) or
FALSE (0), while dfll_fetch_pwm_params() returns 0 on success
or an ERR code on failure.

So this patch fixes the bug of returning 0 on failure.

Fixes: 36541f0499fe ("clk: tegra: dfll: support PWM regulator control")
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/tegra/clk-dfll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/tegra/clk-dfll.c
+++ b/drivers/clk/tegra/clk-dfll.c
@@ -1801,13 +1801,13 @@ static int dfll_fetch_pwm_params(struct
 			    &td->reg_init_uV);
 	if (!ret) {
 		dev_err(td->dev, "couldn't get initialized voltage\n");
-		return ret;
+		return -EINVAL;
 	}
 
 	ret = read_dt_param(td, "nvidia,pwm-period-nanoseconds", &pwm_period);
 	if (!ret) {
 		dev_err(td->dev, "couldn't get PWM period\n");
-		return ret;
+		return -EINVAL;
 	}
 	td->pwm_rate = (NSEC_PER_SEC / pwm_period) * (MAX_DFLL_VOLTAGES - 1);
 


