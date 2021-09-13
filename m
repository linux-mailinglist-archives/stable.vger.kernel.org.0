Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259BE408EC2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242557AbhIMNgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242977AbhIMNeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03C7B6113E;
        Mon, 13 Sep 2021 13:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539612;
        bh=6WR/PA9doHS9lRfGDEn/9vjBBD+HOGYCtRs8PzhaRh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyWzJ5omfayvkqYW5LqlM5O6mgcaJgn2CZlWh/Wm41YkHOCMwu/gzdqh4IcxEX+yM
         6icnQNvW+pCRFz8xHZtjHCxCNwfVkmFZHf5mhdfKWlcOx4dS5Sf/FG6PuCamswQ76a
         TXkfrRbOnQKcuZLKBEG6pgaq8PTt5cylGk9DcdGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/236] regulator: vctrl: Use locked regulator_get_voltage in probe path
Date:   Mon, 13 Sep 2021 15:12:49 +0200
Message-Id: <20210913131102.541106084@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 98e47570ba985f2310586c80409238200fa3170f ]

In commit e9153311491d ("regulator: vctrl-regulator: Avoid deadlock getting
and setting the voltage"), all calls to get/set the voltage of the
control regulator were switched to unlocked versions to avoid deadlocks.
However, the call in the probe path is done without regulator locks
held. In this case the locked version should be used.

Switch back to the locked regulator_get_voltage() in the probe path to
avoid any mishaps.

Fixes: e9153311491d ("regulator: vctrl-regulator: Avoid deadlock getting and setting the voltage")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20210825033704.3307263-2-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/vctrl-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/vctrl-regulator.c b/drivers/regulator/vctrl-regulator.c
index cbadb1c99679..93d33201ffe0 100644
--- a/drivers/regulator/vctrl-regulator.c
+++ b/drivers/regulator/vctrl-regulator.c
@@ -490,7 +490,8 @@ static int vctrl_probe(struct platform_device *pdev)
 		if (ret)
 			return ret;
 
-		ctrl_uV = regulator_get_voltage_rdev(vctrl->ctrl_reg->rdev);
+		/* Use locked consumer API when not in regulator framework */
+		ctrl_uV = regulator_get_voltage(vctrl->ctrl_reg);
 		if (ctrl_uV < 0) {
 			dev_err(&pdev->dev, "failed to get control voltage\n");
 			return ctrl_uV;
-- 
2.30.2



