Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6122029B849
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799978AbgJ0Pe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799975AbgJ0Pe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7148522264;
        Tue, 27 Oct 2020 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812866;
        bh=4FSHkyGDEJlMRqOcMyHyaYqZjUMU1xhbCf15M4ZTGDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erSgs80ILdWPoEf53IGdLkJUIfAHedG0IKMDVhJHQvUBXiMWk1+R6N7UkwnfhqH4w
         uqu2UEqt7i+r8qSLVKNVi2P7MEH9cRAI32ToGRzGNjugi2nAStUtrhimvIfUCkkdUq
         smKOP8+K8NHezRRSW5o0BBeE767mpgXpuyC8d7P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trent Piepho <tpiepho@gmail.com>,
        Drew Fustini <drew@beagleboard.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 358/757] pinctrl: single: fix pinctrl_spec.args_count bounds check
Date:   Tue, 27 Oct 2020 14:50:08 +0100
Message-Id: <20201027135507.363475967@linuxfoundation.org>
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

[ Upstream commit 9b9448f39e83d8e6fdfed006c5db8c304a98c2cd ]

The property #pinctrl-cells can either be 1 or 2:

- if #pinctrl-cells = <1>, then pinctrl_spec.args_count = 2
- if #pinctrl-cells = <2>, then pinctrl_spec.args_count = 3

All other values of pinctrl_spec.args_count are incorrect.  This fix
checks the upper bound instead of just the lower bound.

Fixes: a13395418888 ("pinctrl: single: parse #pinctrl-cells = 2")
Reported-by: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/linux-omap/3139716.CMS8C0sQ7x@zen.local/
Link: https://lore.kernel.org/r/20200930174839.1308344-1-drew@beagleboard.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index efe41abc5d472..5cbf0e55087c6 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1014,7 +1014,7 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 		if (res)
 			return res;
 
-		if (pinctrl_spec.args_count < 2) {
+		if (pinctrl_spec.args_count < 2 || pinctrl_spec.args_count > 3) {
 			dev_err(pcs->dev, "invalid args_count for spec: %i\n",
 				pinctrl_spec.args_count);
 			break;
-- 
2.25.1



