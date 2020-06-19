Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448032012F3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391568AbgFSPTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404142AbgFSPRR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:17:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3C65217D8;
        Fri, 19 Jun 2020 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579836;
        bh=Qv0tFFfHWzsY22XVs0WElWgRqwc3I67cMuLhJLgSdZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrLUlte4pt5KoWxfI/O2h1zOevENWkBUS3krGtTK8DUD25FxoaqfBrhngHQ1RlYDO
         d2Kq9UJMHpnwR/1AwMoi1+9+a+5zvb4DKouaH+dfF1CyHQtw4aaJye2WF6ZFMqVi6N
         skCGwZk9Jd9+suqQmBzNFcVriEajNg4bVZt5Lwq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Shobhit Srivastava <shobhit.srivastava@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 023/376] spi: pxa2xx: Apply CS clk quirk to BXT
Date:   Fri, 19 Jun 2020 16:29:01 +0200
Message-Id: <20200619141711.456668064@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

[ Upstream commit 6eefaee4f2d366a389da0eb95e524ba82bf358c4 ]

With a couple allies at Intel, and much badgering, I got confirmation
from Intel that at least BXT suffers from the same SPI chip-select
issue as Cannonlake (and beyond). The issue being that after going
through runtime suspend/resume, toggling the chip-select line without
also sending data does nothing.

Add the quirk to BXT to briefly toggle dynamic clock gating off and
on, forcing the fabric to wake up enough to notice the CS register
change.

Signed-off-by: Evan Green <evgreen@chromium.org>
Cc: Shobhit Srivastava <shobhit.srivastava@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200427163238.1.Ib1faaabe236e37ea73be9b8dcc6aa034cb3c8804@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index f6e87344a36c..6721910e5f2a 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -150,6 +150,7 @@ static const struct lpss_config lpss_platforms[] = {
 		.tx_threshold_hi = 48,
 		.cs_sel_shift = 8,
 		.cs_sel_mask = 3 << 8,
+		.cs_clk_stays_gated = true,
 	},
 	{	/* LPSS_CNL_SSP */
 		.offset = 0x200,
-- 
2.25.1



