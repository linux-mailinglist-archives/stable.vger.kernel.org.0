Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457304891D0
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiAJHgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33814 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239720AbiAJHdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 247E3B81211;
        Mon, 10 Jan 2022 07:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D028C36AEF;
        Mon, 10 Jan 2022 07:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799995;
        bh=ZTHZRmQnobjicwLrjjyL8/R91C9QzgP8gTl+50ubP0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUKdf59LhuyTMPx/xhRXPbuh9rOViQ2OgGC1gJNI7c8arNhvz5HcHP05Ff8YdSzQt
         cquEwvo18myWYpnq1ijrbiVRp8GhJkym0piDaYu1DW7N+w0E1hqlLdUfLm62kBzJJd
         XmMEFMVEirCyAsXJ/ajtKBPJm0TKjSvSH5fK4R8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.15 43/72] reset: renesas: Fix Runtime PM usage
Date:   Mon, 10 Jan 2022 08:23:20 +0100
Message-Id: <20220110071823.015359869@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 92c959bae2e54ba1e2540ba5f813f7752bd76be1 upstream.

If pm_runtime_resume_and_get() fails then it returns w/o the RPM usage
counter being incremented. In this case call pm_runtime_put() in
remove() will result in a usage counter imbalance. Therefore check the
return code of pm_runtime_resume_and_get() and bail out in case of error.

Fixes: bee08559701f ("reset: renesas: Add RZ/G2L usbphy control driver")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/ec24e13f-0530-b091-7a08-864577b9b3be@gmail.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/reset-rzg2l-usbphy-ctrl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/reset/reset-rzg2l-usbphy-ctrl.c
+++ b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
@@ -137,7 +137,12 @@ static int rzg2l_usbphy_ctrl_probe(struc
 	dev_set_drvdata(dev, priv);
 
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_resume_and_get(&pdev->dev);
+	error = pm_runtime_resume_and_get(&pdev->dev);
+	if (error < 0) {
+		pm_runtime_disable(&pdev->dev);
+		reset_control_assert(priv->rstc);
+		return dev_err_probe(&pdev->dev, error, "pm_runtime_resume_and_get failed");
+	}
 
 	/* put pll and phy into reset state */
 	spin_lock_irqsave(&priv->lock, flags);


