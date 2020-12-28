Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE812E3DBA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440595AbgL1OTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441594AbgL1OTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96A8020791;
        Mon, 28 Dec 2020 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165105;
        bh=Kb6FM557K7LQCJDekFluo1OE78MT6aUs15VIRAGVmlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlNExq8B7Koos5LzTCMIN/VQUvVW0si8/V+rOpr2JHSslL+KeG7X7aoECQByhUmNN
         qSfGDEEYXkHrrqUGNrGW2JU/4sP2DPFk4ZN+e4zCUTSm9uCpHg7YfE8GYiPRAfJFa9
         uvaQ8GLa7L5xQ0cYmEBzriq0cHsb+/70ZfObESYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/717] bus: fsl-mc: add back accidentally dropped error check
Date:   Mon, 28 Dec 2020 13:46:21 +0100
Message-Id: <20201228125039.353044302@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit 61243c03dde238170001093a29716c2369e8358f ]

A previous patch accidentally dropped an error check, so add it back.

Fixes: aef85b56c3c1 ("bus: fsl-mc: MC control registers are not always available")
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Link: https://lore.kernel.org/r/20201105153050.19662-1-laurentiu.tudor@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 76a6ee505d33d..806766b1b45f6 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -967,8 +967,11 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, mc);
 
 	plat_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (plat_res)
+	if (plat_res) {
 		mc->fsl_mc_regs = devm_ioremap_resource(&pdev->dev, plat_res);
+		if (IS_ERR(mc->fsl_mc_regs))
+			return PTR_ERR(mc->fsl_mc_regs);
+	}
 
 	if (mc->fsl_mc_regs && IS_ENABLED(CONFIG_ACPI) &&
 	    !dev_of_node(&pdev->dev)) {
-- 
2.27.0



