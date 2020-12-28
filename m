Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E62E3C95
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437381AbgL1OEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437372AbgL1OEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0B5D207A9;
        Mon, 28 Dec 2020 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164231;
        bh=rsdvLYRZgFKBGP3ZyoaXO42+9Er236h7+jdmEVgjGsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXBIQnoiDwO8T0w+rq9WMrPlZWDcN5iN7BXN+OI+7hSbzxMyBe5j8R5ZrQI0p0T/s
         7u2+R3f9Y2YGvf0Per4Y/Rm1THqx35tNxrs7GNd7rlmotcGAgzE7thtWlmNmlNPRSv
         gi1zqqThrbLxm4wGTQsTHWmeZvFKGWW1q5ZBoZKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/717] soc: ti: omap-prm: Do not check rstst bit on deassert if already deasserted
Date:   Mon, 28 Dec 2020 13:41:44 +0100
Message-Id: <20201228125026.034153545@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit c1995e5afaf6abf3922b5395ad1f4096951e3276 ]

If a rstctrl reset bit is already deasserted, we can just bail out early
not wait for rstst to clear. Otherwise we can have deassert fail for
already deasserted resets.

Fixes: c5117a78dd88 ("soc: ti: omap-prm: poll for reset complete during de-assert")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index 980b04c38fd94..4d41dc3cdce1f 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -484,6 +484,10 @@ static int omap_reset_deassert(struct reset_controller_dev *rcdev,
 	struct ti_prm_platform_data *pdata = dev_get_platdata(reset->dev);
 	int ret = 0;
 
+	/* Nothing to do if the reset is already deasserted */
+	if (!omap_reset_status(rcdev, id))
+		return 0;
+
 	has_rstst = reset->prm->data->rstst ||
 		(reset->prm->data->flags & OMAP_PRM_HAS_RSTST);
 
-- 
2.27.0



