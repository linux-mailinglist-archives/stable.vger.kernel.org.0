Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E84526B592
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgIOXrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgIOOdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1BFE23BE3;
        Tue, 15 Sep 2020 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179887;
        bh=cDT0847aT75pAqdx4y6V4gjKxPC98U4W/+Bq3lZNOWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVN3KCKLxwUbjVGNunektrlfYgBut/aDKRbpx5fN88neHVP58eQUcFB6q+fSlXmw/
         fwZrBnmIk+TgbGcFFjTb6TgEWybhkYu3iDmXjZpvdM8y9uahOYXzv01PejaCuBEXdf
         T2PlhNTiyoRhVhmkA+MFUNFGAI7rWglw14fSNPiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 006/177] regulator: remove superfluous lock in regulator_resolve_coupling()
Date:   Tue, 15 Sep 2020 16:11:17 +0200
Message-Id: <20200915140653.933221961@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit a577f3456c0a2fac3dee037c483753e6e68f3e49 ]

The code modifies rdev, but locks c_rdev instead. Remove the lock
as this is held together by regulator_list_mutex taken in the caller.

Fixes: f9503385b187 ("regulator: core: Mutually resolve regulators coupling")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/25eb81cefb37a646f3e44eaaf1d8ae8881cfde52.1597195321.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 86107d2e1733e..0ba5ca7082afd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4891,13 +4891,9 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 			return;
 		}
 
-		regulator_lock(c_rdev);
-
 		c_desc->coupled_rdevs[i] = c_rdev;
 		c_desc->n_resolved++;
 
-		regulator_unlock(c_rdev);
-
 		regulator_resolve_coupling(c_rdev);
 	}
 }
-- 
2.25.1



