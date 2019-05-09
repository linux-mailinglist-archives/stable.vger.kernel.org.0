Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05546190ED
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfEISuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbfEISun (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FEB120578;
        Thu,  9 May 2019 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427843;
        bh=IvzcrKKjUaGhShNfGWas+gHJsnT1+Y7lxcLDpEGJ1kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MntGGDgDlREj3vxT74NVdB/QJga+Vx4bTUw5PnvGX0h3mjQElclj5C+HJQ6pxBjEo
         ih/JMa5pZv3do9w1aLNvdJnbRK4L/tmPd/RV5lnlFnEDVBUUIsntDeFk5PFxcy1cZt
         bAwKWn0wClot2Ba32XAjiU8KYpeZZvdmyLxBVNK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Jourdan <mjourdan@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 24/95] clk: meson-gxbb: round the vdec dividers to closest
Date:   Thu,  9 May 2019 20:41:41 +0200
Message-Id: <20190509181311.014770082@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9b70c697e87286ade406e6a02091757307dd4b7c ]

We want the video decoder clocks to always round to closest. While the
muxes are already using CLK_MUX_ROUND_CLOSEST, the corresponding
CLK_DIVIDER_ROUND_CLOSEST was forgotten for the dividers.

Fix this by adding the flag to the two vdec dividers.

Fixes: a565242eb9fc ("clk: meson: gxbb: add the video decoder clocks")
Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lkml.kernel.org/r/20190319102537.2043-1-mjourdan@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index 65f2599e52434..08824b2cd1428 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -2213,6 +2213,7 @@ static struct clk_regmap gxbb_vdec_1_div = {
 		.offset = HHI_VDEC_CLK_CNTL,
 		.shift = 0,
 		.width = 7,
+		.flags = CLK_DIVIDER_ROUND_CLOSEST,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "vdec_1_div",
@@ -2258,6 +2259,7 @@ static struct clk_regmap gxbb_vdec_hevc_div = {
 		.offset = HHI_VDEC2_CLK_CNTL,
 		.shift = 16,
 		.width = 7,
+		.flags = CLK_DIVIDER_ROUND_CLOSEST,
 	},
 	.hw.init = &(struct clk_init_data){
 		.name = "vdec_hevc_div",
-- 
2.20.1



