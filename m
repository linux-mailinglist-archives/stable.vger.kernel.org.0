Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CD02C9A5E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387706AbgLAI5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387762AbgLAI5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:57:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C1C22250;
        Tue,  1 Dec 2020 08:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812975;
        bh=RPqcXIlDlB+4+RN1b9MSkZEsEpMrhpb438RyuRLWWM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmqs6oBrxsWC01OvTB6m+x0NMifsGVbOSZz5EafaK6jkeiyg0vIMCSzVbZEKG2/GW
         nsbvSML6lmC92TbVlD7F2Z+i/LrQ1vaIwlr2CeO4zFw7n8Vl/wvFg/kUopyd8AfDA+
         YE80QHj27dvy/z2zCBcSM4XJ3gi0mBE2Mg7gRf+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 40/42] regulator: workaround self-referent regulators
Date:   Tue,  1 Dec 2020 09:53:38 +0100
Message-Id: <20201201084645.890848252@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>

commit f5c042b23f7429e5c2ac987b01a31c69059a978b upstream

Workaround regulators whose supply name happens to be the same as its
own name. This fixes boards that used to work before the early supply
resolving was removed. The error message is left in place so that
offending drivers can be detected.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de> # stpmic1
Link: https://lore.kernel.org/r/d703acde2a93100c3c7a81059d716c50ad1b1f52.1605226675.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1553,7 +1553,10 @@ static int regulator_resolve_supply(stru
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
-		return -EINVAL;
+		if (!have_full_constraints())
+			return -EINVAL;
+		r = dummy_regulator_rdev;
+		get_device(&r->dev);
 	}
 
 	/* Recursively resolve the supply of the supply */


