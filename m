Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E650228821
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390461AbfEWTWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390457AbfEWTWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8121217D9;
        Thu, 23 May 2019 19:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639341;
        bh=/ooMEr3sMXswUrQXLTg5AgIOva1OMjNOZyVecNJhe0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrK49qHD1IbS2tBQhOTDghI5ZGNMJGm1kJMPdc5rGc0oYAEHiDbDsUM+0aoB6jB09
         446Z3g/SQIq1AsNQ8rERfD2WG7jPWisAexbs03Jl8G2swEsd42Zfadlr/EYFIwsKOU
         juQuhr+jLb4x8DjHMWfPDQSt/rn/bwaSkCfL05iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.0 069/139] memory: tegra: Fix integer overflow on tick value calculation
Date:   Thu, 23 May 2019 21:05:57 +0200
Message-Id: <20190523181729.816033188@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit b906c056b6023c390f18347169071193fda57dde upstream.

Multiplying the Memory Controller clock rate by the tick count results
in an integer overflow and in result the truncated tick value is being
programmed into hardware, such that the GR3D memory client performance is
reduced by two times.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/tegra/mc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -280,7 +280,7 @@ static int tegra_mc_setup_latency_allowa
 	u32 value;
 
 	/* compute the number of MC clock cycles per tick */
-	tick = mc->tick * clk_get_rate(mc->clk);
+	tick = (unsigned long long)mc->tick * clk_get_rate(mc->clk);
 	do_div(tick, NSEC_PER_SEC);
 
 	value = readl(mc->regs + MC_EMEM_ARB_CFG);


