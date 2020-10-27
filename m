Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D1D29BCAE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810225AbgJ0Qgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801874AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B5312244C;
        Tue, 27 Oct 2020 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813449;
        bh=yoor9obFPJsJ8Q7aTj6W9WMDFHCloPpeuoKFBiIlTdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVfyp15oFt2YDeDpR9aCLA7fwHY9mZdXPRPOeQtOK+AZXFs8T+hqBQx7Lnfu1wYdE
         bkGmWkZ90+rlpsySxRV/VoDOUMPYcgK817UzLmmWpAUBa/a6mQn+YPryhjQaX5HcQp
         /o2wBPrzAHi+2ZSs3E8eFnsJBU81GjzvkjrenRg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Taniya Das <tdas@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 556/757] clk: qcom: gdsc: Keep RETAIN_FF bit set if gdsc is already on
Date:   Tue, 27 Oct 2020 14:53:26 +0100
Message-Id: <20201027135516.570992741@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit fda48bf5c86d88fd7074e318f290ad636dff4eaa ]

If the GDSC is enabled out of boot but doesn't have the retain ff bit
set we will get confusing results where the registers that are powered
by the GDSC lose their contents on the first power off of the GDSC but
thereafter they retain their contents. This is because gdsc_init() fails
to make sure the RETAIN_FF bit is set when it probes the GDSC the first
time and thus powering off the GDSC causes the register contents to be
reset. We do set the RETAIN_FF bit the next time we power on the GDSC,
see gdsc_enable(), so that subsequent GDSC power off's don't lose
register contents state.

Forcibly set the bit at device probe time so that the kernel's assumed
view of the GDSC is consistent with the state of the hardware. This
fixes a problem where the audio PLL doesn't work on sc7180 when the
bootloader leaves the lpass_core_hm GDSC enabled at boot (e.g. to make a
noise) but critically doesn't set the RETAIN_FF bit.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Taniya Das <tdas@codeaurora.org>
Cc: Rajendra Nayak <rnayak@codeaurora.org>
Fixes: 173722995cdb ("clk: qcom: gdsc: Add support to enable retention of GSDCR")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20201017020137.1251319-1-sboyd@kernel.org
Reviewed-by: Taniya Das <tdas@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org> Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index bfc4ac02f9ea2..af26e0695b866 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -358,6 +358,14 @@ static int gdsc_init(struct gdsc *sc)
 	if ((sc->flags & VOTABLE) && on)
 		gdsc_enable(&sc->pd);
 
+	/*
+	 * Make sure the retain bit is set if the GDSC is already on, otherwise
+	 * we end up turning off the GDSC and destroying all the register
+	 * contents that we thought we were saving.
+	 */
+	if ((sc->flags & RETAIN_FF_ENABLE) && on)
+		gdsc_retain_ff_on(sc);
+
 	/* If ALWAYS_ON GDSCs are not ON, turn them ON */
 	if (sc->flags & ALWAYS_ON) {
 		if (!on)
-- 
2.25.1



