Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB2529B84B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799987AbgJ0Pea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799983AbgJ0Pe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 377AA22275;
        Tue, 27 Oct 2020 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812868;
        bh=b2Y+vhir8kKgFpp4jQGvrmMQ/rEMkP9ovVUWQTDDKpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZR297gZhHIzwnCBS64w1jqjSYlXE084puleD5Mz0rBhiNpG8eD1oumfo7c95xri98
         8heetbA464dCnZUdGymVphLz/oC8UdyoyFn8AY2EZISdU9yCQ2656TUiB+ynS+KN0B
         rI96i+RdGReL435W6uTIP/jVMOyZKnA5OuoEzKLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trent Piepho <tpiepho@gmail.com>,
        Drew Fustini <drew@beagleboard.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 359/757] pinctrl: single: fix debug output when #pinctrl-cells = 2
Date:   Tue, 27 Oct 2020 14:50:09 +0100
Message-Id: <20201027135507.411119042@linuxfoundation.org>
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

From: Drew Fustini <drew@beagleboard.org>

[ Upstream commit f4a2b19c37caf40f3b8487ccb9032b974a84a3a7 ]

The debug output in pcs_parse_one_pinctrl_entry() needs to be updated
to print the correct pinctrl register value when #pinctrl-cells is 2.

Fixes: a13395418888 ("pinctrl: single: parse #pinctrl-cells = 2")
Reported-by: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/linux-omap/3139716.CMS8C0sQ7x@zen.local/
Link: https://lore.kernel.org/r/20200913230306.2061645-1-drew@beagleboard.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 5cbf0e55087c6..f3cd7e2967126 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1033,7 +1033,7 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 		}
 
 		dev_dbg(pcs->dev, "%pOFn index: 0x%x value: 0x%x\n",
-			pinctrl_spec.np, offset, pinctrl_spec.args[1]);
+			pinctrl_spec.np, offset, vals[found].val);
 
 		pin = pcs_get_pin_by_offset(pcs, offset);
 		if (pin < 0) {
-- 
2.25.1



