Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1642C0922
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbgKWNE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387617AbgKWMvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3675C20888;
        Mon, 23 Nov 2020 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135868;
        bh=sg1JOHyWtYPStlkwHoF50Q3T1GwUoNf/2HAP42eTumY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaB+UEyzYZJ/nmNFNIo1HZkZb4QqBmUAqo+hHnu6qkGEHPkdepLc3Dx86xoRG2CHy
         lEztJFMzh+hIySvD5qYc6ZjL+qxdvSJSDlUOhV2ai3YXzlYYHH09Vm+T5YrpeVB/ZD
         76143nYRhRn9hWPMs3Dty8P/NOxX8ypQ7HS1/ozM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.9 225/252] regulator: workaround self-referent regulators
Date:   Mon, 23 Nov 2020 13:22:55 +0100
Message-Id: <20201123121846.432453084@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit f5c042b23f7429e5c2ac987b01a31c69059a978b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1808,7 +1808,10 @@ static int regulator_resolve_supply(stru
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
-		return -EINVAL;
+		if (!have_full_constraints())
+			return -EINVAL;
+		r = dummy_regulator_rdev;
+		get_device(&r->dev);
 	}
 
 	/*


