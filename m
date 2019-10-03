Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8168CA3C4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389631AbfJCQSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389623AbfJCQSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:18:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A6B20865;
        Thu,  3 Oct 2019 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119525;
        bh=sByufSALIAPF6n01zQQTJHouuIvhtjNGtpPcRB30gDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Wjk3iyGT6YJQRMSaVC+nA0csFfcTtJp05hNg2He17ojyqkknqyY8qohpbobw4G2b
         29rxcPDrCJwJUl+BGmE5B06nwNhWtTE5wEKeyfEbXP2ZIALswOxdObXkeR9c/c7uA4
         miTJYqfXcQ0tUePo0enkssYWGyN9ZZgZ94RHMaWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/211] PM / devfreq: passive: Use non-devm notifiers
Date:   Thu,  3 Oct 2019 17:52:43 +0200
Message-Id: <20191003154508.968660081@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3bc29acbd54e8..22fd41b4c1098 100644
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



