Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86957283AB4
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgJEPgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgJEPce (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61273206DD;
        Mon,  5 Oct 2020 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911952;
        bh=MCQz+KguEDfWxlQPuiO4MegJXlw2ki31Y4guoRQTfwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v30U4FpeyqFqx1AdVlEodzLcXi2xkE0VfypXjTaY++yjliaydMdXKlb02ut5vobJ8
         AtjvOCQK6DbVtBkTvC25kaB5/vvB1C/2nFrALaLhQ8mvVBIoU2ialMOYW2FdWPfTD/
         deZH+hH5E7AMmVIQYS2I3Dam4B8WaQNTR4WET9fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5.8 13/85] clk: samsung: Keep top BPLL mux on Exynos542x enabled
Date:   Mon,  5 Oct 2020 17:26:09 +0200
Message-Id: <20201005142115.370229476@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 0212a0483b0a36cc94cfab882b3edbb41fcfe1cd upstream.

BPLL clock must not be disabled because it is needed for proper DRAM
operation. This is normally handled by respective memory devfreq driver,
but when that driver is not yet probed or its probe has been deferred
the clock might get disabled what causes board hang. Fix this by calling
clk_prepare_enable() directly from the clock provider driver.

Cc: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200807133143.22748-1-m.szyprowski@samsung.com
Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/samsung/clk-exynos5420.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -1655,6 +1655,11 @@ static void __init exynos5x_clk_init(str
 	 * main G3D clock enablement status.
 	 */
 	clk_prepare_enable(__clk_lookup("mout_sw_aclk_g3d"));
+	/*
+	 * Keep top BPLL mux enabled permanently to ensure that DRAM operates
+	 * properly.
+	 */
+	clk_prepare_enable(__clk_lookup("mout_bpll"));
 
 	samsung_clk_of_add_provider(np, ctx);
 }


