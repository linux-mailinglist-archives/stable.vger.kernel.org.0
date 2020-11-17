Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3512B60D7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgKQNNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbgKQNNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:13:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC75F24199;
        Tue, 17 Nov 2020 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618792;
        bh=GiKTxWptGcefTqyv9+6bBRFNNeCcS4vNi9GvRyXSJsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jngx/z5i8zx3zIWzzL7tYgDy4r4YQsR3V9ExINCqXhquqQifh0QBg9Efaajhy51qR
         63bB8roeob+5rklXML8YaHrcFO1+evrVulYXEZlgxi+9nKZMin5XQ00Q2HMnxT+TEG
         xiyn0ftauBsRnWTSrgifl49qd8CQlciR/IGdMbHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/85] regulator: defer probe when trying to get voltage from unresolved supply
Date:   Tue, 17 Nov 2020 14:04:30 +0100
Message-Id: <20201117122111.088811490@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit cf1ad559a20d1930aa7b47a52f54e1f8718de301 ]

regulator_get_voltage_rdev() is called in regulator probe() when
applying machine constraints.  The "fixed" commit exposed the problem
that non-bypassed regulators can forward the request to its parent
(like bypassed ones) supply. Return -EPROBE_DEFER when the supply
is expected but not resolved yet.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reported-by: Ondřej Jirman <megous@megous.com>
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Ondřej Jirman <megous@megous.com>
Link: https://lore.kernel.org/r/a9041d68b4d35e4a2dd71629c8a6422662acb5ee.1604351936.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a3c265177855d..978e145b5c8f9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3217,6 +3217,8 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
 		ret = rdev->desc->fixed_uV;
 	} else if (rdev->supply) {
 		ret = _regulator_get_voltage(rdev->supply->rdev);
+	} else if (rdev->supply_name) {
+		return -EPROBE_DEFER;
 	} else {
 		return -EINVAL;
 	}
-- 
2.27.0



