Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBDA111CA4
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfLCWqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbfLCWqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B2620656;
        Tue,  3 Dec 2019 22:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413164;
        bh=fEQiDUCb39lqUiZBntSH+QRXATIRNjIAz3kmwPEpB0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvSjZ/htZyB6QuyuQlE9yrmSvrdqR6yDzrVsxwrn21IGMM/L4pZQMzFsez4UkBEu4
         m+57vx0MxieXpgWAnDfwMihkhhdNU7nop1JeYEqiwClfSA+CRwxfDFVt2OBJMMbScC
         wNzA6jFZEiWsGZ+048W9Uowz6O8jqnMEONNOppaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/321] clk: ti: clkctrl: Fix failed to enable error with double udelay timeout
Date:   Tue,  3 Dec 2019 23:31:29 +0100
Message-Id: <20191203223428.325017363@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 81a41901ffd46bac6df4c95b8290ac259e0feda8 ]

Commit 3d8598fb9c5a ("clk: ti: clkctrl: use fallback udelay approach if
timekeeping is suspended") added handling for cases when timekeeping is
suspended. But looks like we can still get occasional "failed to enable"
errors on the PM runtime resume path with udelay() returning faster than
expected.

With ti-sysc interconnect target module driver this leads into device
failure with PM runtime failing with "failed to enable" clkctrl error.

Let's fix the issue with a delay of two times the desired delay as in
often done for udelay() to account for the inaccuracy.

Fixes: 3d8598fb9c5a ("clk: ti: clkctrl: use fallback udelay approach if timekeeping is suspended")
Cc: Keerthy <j-keerthy@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lkml.kernel.org/r/20190930154001.46581-1-tony@atomide.com
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clkctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ti/clkctrl.c b/drivers/clk/ti/clkctrl.c
index dfaa5aad06927..2c2564acad227 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -100,11 +100,12 @@ static bool _omap4_is_timeout(union omap4_timeout *time, u32 timeout)
 	 * can be from a timer that requires pm_runtime access, which
 	 * will eventually bring us here with timekeeping_suspended,
 	 * during both suspend entry and resume paths. This happens
-	 * at least on am43xx platform.
+	 * at least on am43xx platform. Account for flakeyness
+	 * with udelay() by multiplying the timeout value by 2.
 	 */
 	if (unlikely(_early_timeout || timekeeping_suspended)) {
 		if (time->cycles++ < timeout) {
-			udelay(1);
+			udelay(1 * 2);
 			return false;
 		}
 	} else {
-- 
2.20.1



