Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D264111C92
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbfLCWp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbfLCWp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9B720803;
        Tue,  3 Dec 2019 22:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413126;
        bh=5UeLwMA8GjwdgJAx5gN06GWImJNf48vZifNNOHnnO9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISxt7qKD+chTim6q8lak+9FudE/fv0BWUMlqjL2sa3ojHk787M+CRZvC6zE5DCvOT
         m8NC2ukfc0G/fmYZcjVhypkLcxq3W3jWSD+X61Ei5wdkYSBUzm7BGJgMGDlUsZXQ3l
         psWaApGKCysZLz8Pq43r0BKiQSBxBVwh1XbT5uyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/321] clk: meson: gxbb: let sar_adc_clk_div set the parent clock rate
Date:   Tue,  3 Dec 2019 23:31:07 +0100
Message-Id: <20191203223427.196896630@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 44b09b11b813b8550e6b976ea51593bc23bba8d1 ]

The meson-saradc driver manually sets the input clock for
sar_adc_clk_sel. Update the GXBB clock driver (which is used on GXBB,
GXL and GXM) so the rate settings on sar_adc_clk_div are propagated up
to sar_adc_clk_sel which will let the common clock framework select the
best matching parent clock if we want that.

This makes sar_adc_clk_div consistent with the axg-aoclk and g12a-aoclk
drivers, which both also specify CLK_SET_RATE_PARENT.

Fixes: 33d0fcdfe0e870 ("clk: gxbb: add the SAR ADC clocks and expose them")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index 4d4f6d842c31c..d94b65061b9f1 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -836,6 +836,7 @@ static struct clk_regmap gxbb_sar_adc_clk_div = {
 		.ops = &clk_regmap_divider_ops,
 		.parent_names = (const char *[]){ "sar_adc_clk_sel" },
 		.num_parents = 1,
+		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.20.1



