Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D030299CD7
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391160AbfHVRh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404256AbfHVRYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:37 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC5B523407;
        Thu, 22 Aug 2019 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494676;
        bh=PlMqAN8+epMELBmyC4iK2dJFZedqwDoHhpGBl5HPV+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocB6QumOm7+VFM7Q7Ya+1Zb8W8Cl2uuTwZYf+awSpVUXgYdjh4NLRaWO4tDZO+mgY
         7wxEAf+3cqcEYyo7katEScTzzW6uPqJbf4lb9jac3o6yGzBFikGLjiwws18rbLYMpY
         uFdUoca9o+SbgvHArOOwE3FoMWo2C3gJKFnWudt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/71] clk: at91: generated: Truncate divisor to GENERATED_MAX_DIV + 1
Date:   Thu, 22 Aug 2019 10:18:56 -0700
Message-Id: <20190822171728.498686520@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1573eebeaa8055777eb753f9b4d1cbe653380c38 ]

In clk_generated_determine_rate(), if the divisor is greater than
GENERATED_MAX_DIV + 1, then the wrong best_rate will be returned.
If clk_generated_set_rate() will be called later with this wrong
rate, it will return -EINVAL, so the generated clock won't change
its value. Do no let the divisor be greater than GENERATED_MAX_DIV + 1.

Fixes: 8c7aa6328947 ("clk: at91: clk-generated: remove useless divisor loop")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-generated.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index 33481368740e7..113152425a95d 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -153,6 +153,8 @@ static int clk_generated_determine_rate(struct clk_hw *hw,
 			continue;
 
 		div = DIV_ROUND_CLOSEST(parent_rate, req->rate);
+		if (div > GENERATED_MAX_DIV + 1)
+			div = GENERATED_MAX_DIV + 1;
 
 		clk_generated_best_diff(req, parent, parent_rate, div,
 					&best_diff, &best_rate);
-- 
2.20.1



