Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81878412199
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358481AbhITSGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357698AbhITSEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7588263242;
        Mon, 20 Sep 2021 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158236;
        bh=H6EkSblXFQSVOVxQUfoJvoAgWaZVRuI4sRREVmvO8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LoHvQof3KwDfRgkaU6SCbCTA32Wjai6Z7VW6ux79e9jHoDFfYPdm5wSJui4WH3BXl
         +XJzBLalOGtFMycSUCPMUtEQh7gMIjAfKSidwwRhA6CtVLFEHC5zmmHKsRuqslTefc
         nuvhLkEO50vBCfexVLo4+HoEg7UWnlUUseGVLX10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/260] clk: at91: clk-generated: Limit the requested rate to our range
Date:   Mon, 20 Sep 2021 18:41:22 +0200
Message-Id: <20210920163933.308817275@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit af7651e67b9d5f7e63ea23b118e3672ac662244a ]

On clk_generated_determine_rate(), the requested rate could be outside
of clk's range. Limit the rate to the clock's range to not return an
error.

Fixes: df70aeef6083 ("clk: at91: add generated clock driver")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20210707131213.3283509-1-codrin.ciubotariu@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-generated.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index 273d0447d727..d7fe1303f79d 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -127,6 +127,12 @@ static int clk_generated_determine_rate(struct clk_hw *hw,
 	int i;
 	u32 div;
 
+	/* do not look for a rate that is outside of our range */
+	if (gck->range.max && req->rate > gck->range.max)
+		req->rate = gck->range.max;
+	if (gck->range.min && req->rate < gck->range.min)
+		req->rate = gck->range.min;
+
 	for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
 		if (gck->chg_pid == i)
 			continue;
-- 
2.30.2



