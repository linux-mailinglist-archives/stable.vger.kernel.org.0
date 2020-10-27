Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BA929AFDD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756475AbgJ0ONc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756472AbgJ0ONb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94CEC2072D;
        Tue, 27 Oct 2020 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808011;
        bh=aUaCq+ABJ015NZQWid6SoBHEGAphAYcU5/XDqh9DNUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK3cgFAqevJ+rGVuJ3Vin62IftPiukx5aTdvX7KRwI0WnHBEszkxq+NRcD40blbtE
         wT2g/K2HKF+SUY8tsvpOm3Qx+Z6oH9r6wyJDZUXkiwAgqFDhZ/t7AnPIJSzNY9gl0+
         4hIglarkv01LYi2K0FxJCl8aI3sPKwIo2HuymRVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/191] Input: twl4030_keypad - fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:49:38 +0100
Message-Id: <20201027134915.608587021@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit c277e1f0dc3c7d7b5b028e20dd414df241642036 ]

platform_get_irq() returns -ERRNO on error.  In such case casting to
unsigned and comparing to 0 would pass the check.

Fixes: 7abf38d6d13c ("Input: twl4030-keypad - add device tree support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200828145744.3636-3-krzk@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/twl4030_keypad.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index f9f98ef1d98e3..8677dbe0fd209 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -63,7 +63,7 @@ struct twl4030_keypad {
 	bool		autorepeat;
 	unsigned int	n_rows;
 	unsigned int	n_cols;
-	unsigned int	irq;
+	int		irq;
 
 	struct device *dbg_dev;
 	struct input_dev *input;
@@ -389,10 +389,8 @@ static int twl4030_kp_probe(struct platform_device *pdev)
 	}
 
 	kp->irq = platform_get_irq(pdev, 0);
-	if (!kp->irq) {
-		dev_err(&pdev->dev, "no keyboard irq assigned\n");
-		return -EINVAL;
-	}
+	if (kp->irq < 0)
+		return kp->irq;
 
 	error = matrix_keypad_build_keymap(keymap_data, NULL,
 					   TWL4030_MAX_ROWS,
-- 
2.25.1



