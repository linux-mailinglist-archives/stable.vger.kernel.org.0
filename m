Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748C429AFC3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900882AbgJ0OMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507061AbgJ0OLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:11:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D06A122264;
        Tue, 27 Oct 2020 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807870;
        bh=U+qVzhEqQ3d6bn6DBQtHddFyD/GJwqjJgMISy17aEgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdAWJCBe1kXRgVI28b9cZognR0jAxDakhM5PJXH+Iq2Mfu6MucSiST5q51hu6Kb+7
         URRuIDdjHqZRKDvFRm19ozWne508PtSeJdsB5QJonf1o4TUJcY3y6IN4oLiUYYpSig
         BeUKXHCqnmIAmRcAuIjPKrBYTVQZQXYPUJXDNZjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/191] regulator: resolve supply after creating regulator
Date:   Tue, 27 Oct 2020 14:48:15 +0100
Message-Id: <20201027134911.667452598@linuxfoundation.org>
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

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit aea6cb99703e17019e025aa71643b4d3e0a24413 ]

When creating a new regulator its supply cannot create the sysfs link
because the device is not yet published. Remove early supply resolving
since it will be done later anyway. This makes the following error
disappear and the symlinks get created instead.

  DCDC_REG1: supplied by VSYS
  VSYS: could not add device link regulator.3 err -2

Note: It doesn't fix the problem for bypassed regulators, though.

Fixes: 45389c47526d ("regulator: core: Add early supply resolution for regulators")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/ba09e0a8617ffeeb25cb4affffe6f3149319cef8.1601155770.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bd6991a99593d..a3c265177855d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4090,15 +4090,20 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	else if (regulator_desc->supply_name)
 		rdev->supply_name = regulator_desc->supply_name;
 
-	/*
-	 * Attempt to resolve the regulator supply, if specified,
-	 * but don't return an error if we fail because we will try
-	 * to resolve it again later as more regulators are added.
-	 */
-	if (regulator_resolve_supply(rdev))
-		rdev_dbg(rdev, "unable to resolve supply\n");
-
 	ret = set_machine_constraints(rdev, constraints);
+	if (ret == -EPROBE_DEFER) {
+		/* Regulator might be in bypass mode and so needs its supply
+		 * to set the constraints */
+		/* FIXME: this currently triggers a chicken-and-egg problem
+		 * when creating -SUPPLY symlink in sysfs to a regulator
+		 * that is just being created */
+		ret = regulator_resolve_supply(rdev);
+		if (!ret)
+			ret = set_machine_constraints(rdev, constraints);
+		else
+			rdev_dbg(rdev, "unable to resolve supply early: %pe\n",
+				 ERR_PTR(ret));
+	}
 	if (ret < 0)
 		goto wash;
 
-- 
2.25.1



