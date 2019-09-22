Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B94BA7DA
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395134AbfIVTAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395131AbfIVTAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:00:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 064B121D81;
        Sun, 22 Sep 2019 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178818;
        bh=p68INXkclvLGmBIJXQaku3HvUMATg5Q2YwTxVLJ28T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsOCLasekDhLNfISphav7gxNoGgKCon+iGcwkkcd0Rf3q0UUq3e0ibGqxyONowLOc
         yioAIWAyiElmQTNZfTO3GLrPMwYEP6KBCG0hgESiOYaSZx2r7EVhZw4kPEvIQPmkzP
         F+3lqqppMVd6S0gfa/F77nTZjwV8w6EmOgwOXMwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 31/60] PM / devfreq: passive: Use non-devm notifiers
Date:   Sun, 22 Sep 2019 14:59:04 -0400
Message-Id: <20190922185934.4305-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185934.4305-1-sashal@kernel.org>
References: <20190922185934.4305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 0ef7c7cce43f6ecc2b96d447e69b2900a9655f7c ]

The devfreq passive governor registers and unregisters devfreq
transition notifiers on DEVFREQ_GOV_START/GOV_STOP using devm wrappers.

If devfreq itself is registered with devm then a warning is triggered on
rmmod from devm_devfreq_unregister_notifier. Call stack looks like this:

	devm_devfreq_unregister_notifier+0x30/0x40
	devfreq_passive_event_handler+0x4c/0x88
	devfreq_remove_device.part.8+0x6c/0x9c
	devm_devfreq_dev_release+0x18/0x20
	release_nodes+0x1b0/0x220
	devres_release_all+0x78/0x84
	device_release_driver_internal+0x100/0x1c0
	driver_detach+0x4c/0x90
	bus_remove_driver+0x7c/0xd0
	driver_unregister+0x2c/0x58
	platform_driver_unregister+0x10/0x18
	imx_devfreq_platdrv_exit+0x14/0xd40 [imx_devfreq]

This happens because devres_release_all will first remove all the nodes
into a separate todo list so the nested devres_release from
devm_devfreq_unregister_notifier won't find anything.

Fix the warning by calling the non-devm APIS for frequency notification.
Using devm wrappers is not actually useful for a governor anyway: it
relies on the devfreq core to correctly match the GOV_START/GOV_STOP
notifications.

Fixes: 996133119f57 ("PM / devfreq: Add new passive governor")
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/governor_passive.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governor_passive.c
index 5be96b2249e72..8e889fd805b58 100644
--- a/drivers/devfreq/governor_passive.c
+++ b/drivers/devfreq/governor_passive.c
@@ -168,12 +168,12 @@ static int devfreq_passive_event_handler(struct devfreq *devfreq,
 			p_data->this = devfreq;
 
 		nb->notifier_call = devfreq_passive_notifier_call;
-		ret = devm_devfreq_register_notifier(dev, parent, nb,
+		ret = devfreq_register_notifier(parent, nb,
 					DEVFREQ_TRANSITION_NOTIFIER);
 		break;
 	case DEVFREQ_GOV_STOP:
-		devm_devfreq_unregister_notifier(dev, parent, nb,
-					DEVFREQ_TRANSITION_NOTIFIER);
+		WARN_ON(devfreq_unregister_notifier(parent, nb,
+					DEVFREQ_TRANSITION_NOTIFIER));
 		break;
 	default:
 		break;
-- 
2.20.1

