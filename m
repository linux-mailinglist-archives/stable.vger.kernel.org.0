Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D87D2C06A3
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbgKWMdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbgKWMdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:33:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88D222065E;
        Mon, 23 Nov 2020 12:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134780;
        bh=ymMJvAfP2wYP6Tu5Rwttw58yVSvHxDFnDpBovnUv35Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GgUao9Y03JWO4Hrs4GcEdJK2YqOVERXJ0jyth9ngxSR7q4V8td1B2InF5URBtirr
         q5gtCBufMnYrnTxqDRD2LL0q6L6ToikRIxH4ZzesMxNtssFizUO700amnfP7pqzuR9
         zAJ+Q9G7meDiCc3KYiZebBpv0Au46jmCnI2GmRAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 80/91] regulator: avoid resolve_supply() infinite recursion
Date:   Mon, 23 Nov 2020 13:22:40 +0100
Message-Id: <20201123121813.213690521@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 4b639e254d3d4f15ee4ff2b890a447204cfbeea9 upstream.

When a regulator's name equals its supply's name the
regulator_resolve_supply() recurses indefinitely. Add a check
so that debugging the problem is easier. The "fixed" commit
just exposed the problem.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de> # stpmic1
Link: https://lore.kernel.org/r/c6171057cfc0896f950c4d8cb82df0f9f1b89ad9.1605226675.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1595,6 +1595,12 @@ static int regulator_resolve_supply(stru
 		}
 	}
 
+	if (r == rdev) {
+		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
+			rdev->desc->name, rdev->supply_name);
+		return -EINVAL;
+	}
+
 	/*
 	 * If the supply's parent device is not the same as the
 	 * regulator's parent device, then ensure the parent device


