Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABEF3783B5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhEJKrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhEJKo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EBFC610C9;
        Mon, 10 May 2021 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642867;
        bh=thT2zXXSLEyJO8vrhb/pHhr0VBGcHpreWczWqA3O9VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks4qUtQQoq7FTTmqtxA5oG6ZrI9vTk+R+l8BNXn6bTLvohdw3ocfwHHFIyh+hxHyM
         cVFQlkUITcHm3YK8DmxEzX+B48M59SZGLZAMTGowZU4pIKyCYP+kWp3t7phEo8xJ/O
         Vqc/iCZGaVYvEX4eTsJ4Mgw6xEig4u2Zp2ITEUvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Anton Bambura <jenneron@protonmail.com>,
        Matt Merhar <mattmerhar@protonmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH 5.10 050/299] cpuidle: tegra: Fix C7 idling state on Tegra114
Date:   Mon, 10 May 2021 12:17:27 +0200
Message-Id: <20210510102006.525907959@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 32c8c34d8132b5fe8497c2538597445a0d65c29d upstream.

Trusted Foundation firmware doesn't implement the do_idle call and in
this case suspending should fall back to the common suspend path. In order
to fix this issue we will unconditionally set the NOFLUSH_L2 mode via
firmware call, which is a NO-OP on Tegra30/124, and then proceed to the
C7 idling, like it was done by the older Tegra114 cpuidle driver.

Fixes: 14e086baca50 ("cpuidle: tegra: Squash Tegra114 driver into the common driver")
Cc: stable@vger.kernel.org # 5.7+
Reported-by: Anton Bambura <jenneron@protonmail.com> # TF701 T114
Tested-by: Anton Bambura <jenneron@protonmail.com> # TF701 T114
Tested-by: Matt Merhar <mattmerhar@protonmail.com> # Ouya T30
Tested-by: Peter Geis <pgwipeout@gmail.com> # Ouya T30
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210302095405.28453-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/cpuidle-tegra.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/cpuidle/cpuidle-tegra.c
+++ b/drivers/cpuidle/cpuidle-tegra.c
@@ -135,13 +135,13 @@ static int tegra_cpuidle_c7_enter(void)
 {
 	int err;
 
-	if (tegra_cpuidle_using_firmware()) {
-		err = call_firmware_op(prepare_idle, TF_PM_MODE_LP2_NOFLUSH_L2);
-		if (err)
-			return err;
+	err = call_firmware_op(prepare_idle, TF_PM_MODE_LP2_NOFLUSH_L2);
+	if (err && err != -ENOSYS)
+		return err;
 
-		return call_firmware_op(do_idle, 0);
-	}
+	err = call_firmware_op(do_idle, 0);
+	if (err != -ENOSYS)
+		return err;
 
 	return cpu_suspend(0, tegra30_pm_secondary_cpu_suspend);
 }


