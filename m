Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75985107064
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfKVKny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfKVKnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:43:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FE6320715;
        Fri, 22 Nov 2019 10:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419432;
        bh=HShIySpLPUNeFNOt26VHwgmGLAKWF2+VsW+uRVUMwGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLhCZQutHFwWZWeF0dS9XhHMW7tg5lLPWLW8DxOsw6v5TrTWfne8xg5PYCch6AVnZ
         nWk/r65sdOms7WfI3fR5MZI2vpg3a5FaP1YcMwjDzI5izD97BRV4iQXhvttDEyikFN
         DLE+dYeqxe06i3GbNsLJXfrIgnsd72vdthJ2h5Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 073/222] power: reset: at91-poweroff: do not procede if at91_shdwc is allocated
Date:   Fri, 22 Nov 2019 11:26:53 +0100
Message-Id: <20191122100907.543194787@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 9f1e44774be578fb92776add95f1fcaf8284d692 ]

There should be only one instance of struct shdwc in the system. This is
referenced through at91_shdwc. Return in probe if at91_shdwc is already
allocated.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/at91-sama5d2_shdwc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/reset/at91-sama5d2_shdwc.c b/drivers/power/reset/at91-sama5d2_shdwc.c
index 90b0b5a70ce52..04ca990e8f6cb 100644
--- a/drivers/power/reset/at91-sama5d2_shdwc.c
+++ b/drivers/power/reset/at91-sama5d2_shdwc.c
@@ -246,6 +246,9 @@ static int __init at91_shdwc_probe(struct platform_device *pdev)
 	if (!pdev->dev.of_node)
 		return -ENODEV;
 
+	if (at91_shdwc)
+		return -EBUSY;
+
 	at91_shdwc = devm_kzalloc(&pdev->dev, sizeof(*at91_shdwc), GFP_KERNEL);
 	if (!at91_shdwc)
 		return -ENOMEM;
-- 
2.20.1



