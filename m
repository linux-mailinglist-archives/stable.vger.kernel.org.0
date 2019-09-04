Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994D6A8DEC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfIDRxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:53:35 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:49464 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731633AbfIDRxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 13:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=iYIeUpDrEBWiGCuNs3OXSzfuqXKPHDOYVNqEcIq84zI=; b=PHwYHOjtzvRy
        nZxGXvdyTWw9rFtgYhq9c6Marg5F+Dxm4hwBNyc8vHMZviaHlawtuaXPDoALLdeL8HE+jyJKBbM/H
        sfXh8EKYFdglj8vu2cJoXtu6oOfL36qvQojyRjbgcoCzM/lxki40QLi+7OIfTBVo9LHDUpd7ibuIj
        GeZj0=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i5ZTH-0006hY-MZ; Wed, 04 Sep 2019 17:53:31 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 3ADAE2742B45; Wed,  4 Sep 2019 18:53:31 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Applied "regulator: Defer init completion for a while after late_initcall" to the regulator tree
In-Reply-To: <20190904124250.25844-1-broonie@kernel.org>
X-Patchwork-Hint: ignore
Message-Id: <20190904175331.3ADAE2742B45@ypsilon.sirena.org.uk>
Date:   Wed,  4 Sep 2019 18:53:31 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   regulator: Defer init completion for a while after late_initcall

has been applied to the regulator tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-5.4

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 55576cf1853798e86f620766e23b604c9224c19c Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@kernel.org>
Date: Wed, 4 Sep 2019 13:42:50 +0100
Subject: [PATCH] regulator: Defer init completion for a while after
 late_initcall

The kernel has no way of knowing when we have finished instantiating
drivers, between deferred probe and systems that build key drivers as
modules we might be doing this long after userspace has booted. This has
always been a bit of an issue with regulator_init_complete since it can
power off hardware that's not had it's driver loaded which can result in
user visible effects, the main case is powering off displays. Practically
speaking it's not been an issue in real systems since most systems that
use the regulator API are embedded and build in key drivers anyway but
with Arm laptops coming on the market it's becoming more of an issue so
let's do something about it.

In the absence of any better idea just defer the powering off for 30s
after late_initcall(), this is obviously a hack but it should mask the
issue for now and it's no more arbitrary than late_initcall() itself.
Ideally we'd have some heuristics to detect if we're on an affected
system and tune or skip the delay appropriately, and there may be some
need for a command line option to be added.

Link: https://lore.kernel.org/r/20190904124250.25844-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Tested-by: Lee Jones <lee.jones@linaro.org>
Cc: stable@vger.kernel.org
---
 drivers/regulator/core.c | 42 +++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4a27a46ec6e7..340db986b67f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5644,7 +5644,7 @@ static int __init regulator_init(void)
 /* init early to allow our consumers to complete system booting */
 core_initcall(regulator_init);
 
-static int __init regulator_late_cleanup(struct device *dev, void *data)
+static int regulator_late_cleanup(struct device *dev, void *data)
 {
 	struct regulator_dev *rdev = dev_to_rdev(dev);
 	const struct regulator_ops *ops = rdev->desc->ops;
@@ -5693,17 +5693,8 @@ static int __init regulator_late_cleanup(struct device *dev, void *data)
 	return 0;
 }
 
-static int __init regulator_init_complete(void)
+static void regulator_init_complete_work_function(struct work_struct *work)
 {
-	/*
-	 * Since DT doesn't provide an idiomatic mechanism for
-	 * enabling full constraints and since it's much more natural
-	 * with DT to provide them just assume that a DT enabled
-	 * system has full constraints.
-	 */
-	if (of_have_populated_dt())
-		has_full_constraints = true;
-
 	/*
 	 * Regulators may had failed to resolve their input supplies
 	 * when were registered, either because the input supply was
@@ -5721,6 +5712,35 @@ static int __init regulator_init_complete(void)
 	 */
 	class_for_each_device(&regulator_class, NULL, NULL,
 			      regulator_late_cleanup);
+}
+
+static DECLARE_DELAYED_WORK(regulator_init_complete_work,
+			    regulator_init_complete_work_function);
+
+static int __init regulator_init_complete(void)
+{
+	/*
+	 * Since DT doesn't provide an idiomatic mechanism for
+	 * enabling full constraints and since it's much more natural
+	 * with DT to provide them just assume that a DT enabled
+	 * system has full constraints.
+	 */
+	if (of_have_populated_dt())
+		has_full_constraints = true;
+
+	/*
+	 * We punt completion for an arbitrary amount of time since
+	 * systems like distros will load many drivers from userspace
+	 * so consumers might not always be ready yet, this is
+	 * particularly an issue with laptops where this might bounce
+	 * the display off then on.  Ideally we'd get a notification
+	 * from userspace when this happens but we don't so just wait
+	 * a bit and hope we waited long enough.  It'd be better if
+	 * we'd only do this on systems that need it, and a kernel
+	 * command line option might be useful.
+	 */
+	schedule_delayed_work(&regulator_init_complete_work,
+			      msecs_to_jiffies(30000));
 
 	return 0;
 }
-- 
2.20.1

