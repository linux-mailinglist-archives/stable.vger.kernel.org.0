Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2317329BCD2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811100AbgJ0QhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801889AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F070F22202;
        Tue, 27 Oct 2020 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813485;
        bh=MzlmVuAvenrDn5vJlUBmv5V5+3UhaYVG+lxeEYlJHW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loW6GObYvFKE2J7SBXK+UB6fem4xLgE6zzyUmdvg0xGU8FGxBi+PatESzeloJd8zr
         2va4jOQRWrIVhQx4WpnC6lcTI+wgVh09ghjKSHSeraRmIqFL4G4R9xH5HymahD237e
         MA1/+iAm67drzJnj/JyMdqu7Uur8X16828w+4KLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 567/757] Input: twl4030_keypad - fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:53:37 +0100
Message-Id: <20201027135517.103645451@linuxfoundation.org>
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
index af3a6824f1a4d..77e0743a3cf85 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -50,7 +50,7 @@ struct twl4030_keypad {
 	bool		autorepeat;
 	unsigned int	n_rows;
 	unsigned int	n_cols;
-	unsigned int	irq;
+	int		irq;
 
 	struct device *dbg_dev;
 	struct input_dev *input;
@@ -376,10 +376,8 @@ static int twl4030_kp_probe(struct platform_device *pdev)
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



