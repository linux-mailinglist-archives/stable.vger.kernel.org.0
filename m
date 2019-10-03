Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C29CAC2A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbfJCQGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732165AbfJCQGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:06:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5763C21783;
        Thu,  3 Oct 2019 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118782;
        bh=j8smlTCBehzplc91QnNf3OQ8s2sd/rgGmQpFtQiNK0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8L3x10CuwyY/UI6q9h8dMx2jngajwaT4rrQfgOe2NqBdnuDLoYxUKAPKKOlc1v6i
         s3ETZ6u1yc/t7MiNvIY3W9t8v0R0/sD+U3O7KKcOlWvhkZ4aIV54j/LrYEs9XQ3ubH
         AVuUywKNTkuyTvvLLGUJoqIMtuXDr1snRJN7vpsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 113/129] regulator: Defer init completion for a while after late_initcall
Date:   Thu,  3 Oct 2019 17:53:56 +0200
Message-Id: <20191003154410.878885887@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 55576cf1853798e86f620766e23b604c9224c19c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4452,7 +4452,7 @@ static int __init regulator_init(void)
 /* init early to allow our consumers to complete system booting */
 core_initcall(regulator_init);
 
-static int __init regulator_late_cleanup(struct device *dev, void *data)
+static int regulator_late_cleanup(struct device *dev, void *data)
 {
 	struct regulator_dev *rdev = dev_to_rdev(dev);
 	const struct regulator_ops *ops = rdev->desc->ops;
@@ -4501,18 +4501,9 @@ unlock:
 	return 0;
 }
 
-static int __init regulator_init_complete(void)
+static void regulator_init_complete_work_function(struct work_struct *work)
 {
 	/*
-	 * Since DT doesn't provide an idiomatic mechanism for
-	 * enabling full constraints and since it's much more natural
-	 * with DT to provide them just assume that a DT enabled
-	 * system has full constraints.
-	 */
-	if (of_have_populated_dt())
-		has_full_constraints = true;
-
-	/*
 	 * Regulators may had failed to resolve their input supplies
 	 * when were registered, either because the input supply was
 	 * not registered yet or because its parent device was not
@@ -4529,6 +4520,35 @@ static int __init regulator_init_complet
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


