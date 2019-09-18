Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DE6B5C36
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfIRGX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729732AbfIRGXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FB721929;
        Wed, 18 Sep 2019 06:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787834;
        bh=acqf8iWr/flWMhoJlMX9Rq4SnUZG25hjg5RNHePwK0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UC8sJ8bJvHlHHR32gRnpXyWtX+sU4uaUVDZn3t55TrWxpHgb1mX7AoMsGKZxBcLnE
         g2HK5SeYvmeRlDU/WAeqmEfARsd+R7XPgw/FsI3nGUcfP+IITHwiM0BZtxJF7sabas
         Diuc49wT5VP6TG0few1Hil+IahxyyauwtaGuhRlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.19 28/50] clk: rockchip: Dont yell about bad mmc phases when getting
Date:   Wed, 18 Sep 2019 08:19:11 +0200
Message-Id: <20190918061226.403676340@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 6943b839721ad4a31ad2bacf6e71b21f2dfe3134 upstream.

At boot time, my rk3288-veyron devices yell with 8 lines that look
like this:
  [    0.000000] rockchip_mmc_get_phase: invalid clk rate

This is because the clock framework at clk_register() time tries to
get the phase but we don't have a parent yet.

While the errors appear to be harmless they are still ugly and, in
general, we don't want yells like this in the log unless they are
important.

There's no real reason to be yelling here.  We can still return
-EINVAL to indicate that the phase makes no sense without a parent.
If someone really tries to do tuning and the clock is reported as 0
then we'll see the yells in rockchip_mmc_set_phase().

Fixes: 4bf59902b500 ("clk: rockchip: Prevent calculating mmc phase if clock rate is zero")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/rockchip/clk-mmc-phase.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/clk/rockchip/clk-mmc-phase.c
+++ b/drivers/clk/rockchip/clk-mmc-phase.c
@@ -61,10 +61,8 @@ static int rockchip_mmc_get_phase(struct
 	u32 delay_num = 0;
 
 	/* See the comment for rockchip_mmc_set_phase below */
-	if (!rate) {
-		pr_err("%s: invalid clk rate\n", __func__);
+	if (!rate)
 		return -EINVAL;
-	}
 
 	raw_value = readl(mmc_clock->reg) >> (mmc_clock->shift);
 


