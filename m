Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D88404EED
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347899AbhIIMQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351217AbhIIMJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7442461245;
        Thu,  9 Sep 2021 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188093;
        bh=JCUyILyV+6ACnUJ0rjVdIkqYyZqashxOxCmyeCo/XRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6H7OTvYtpEIhEqiIBvND4fCn4ixDLyYSWG5u07hujcKoEum6xrGhw9TN/MYTgkpl
         Jqcv1VZykby/c18dfeTwNVKmQiur+EVfjz45mZgEcrcr3cYWRwfQqt7jU5cfugiSnI
         dSGH7QpG0VYva9gzm+dJzRX2cz3tTkaTTUQ9JZBbVdivXic9xtCI/dvxxICyUjdYCM
         +bw1x+NgzMsFVdHIolvjoYmak+NoB1V55cPbbywnXCnVFhdkwJ38c/mE+h4WncyFyx
         /worvX5GO9Jr4b+C4DjzNQ/eRPfgsGUJqdf3d7YPAGFABnHRD7VXDEYbV79C011vfT
         7jMVN8kXyGGTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 076/219] drm: rcar-du: Shutdown the display on system shutdown
Date:   Thu,  9 Sep 2021 07:44:12 -0400
Message-Id: <20210909114635.143983-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 015f2ebb93767d40c442e749642fffaf10316d78 ]

When the system shuts down or warm reboots, the display may be active,
with the hardware accessing system memory. Upon reboot, the DDR will not
be accessible, which may cause issues.

Implement the platform_driver .shutdown() operation and shut down the
display to fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index bfbff90588cb..43de3d8686e8 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -561,6 +561,13 @@ static int rcar_du_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void rcar_du_shutdown(struct platform_device *pdev)
+{
+	struct rcar_du_device *rcdu = platform_get_drvdata(pdev);
+
+	drm_atomic_helper_shutdown(&rcdu->ddev);
+}
+
 static int rcar_du_probe(struct platform_device *pdev)
 {
 	struct rcar_du_device *rcdu;
@@ -617,6 +624,7 @@ static int rcar_du_probe(struct platform_device *pdev)
 static struct platform_driver rcar_du_platform_driver = {
 	.probe		= rcar_du_probe,
 	.remove		= rcar_du_remove,
+	.shutdown	= rcar_du_shutdown,
 	.driver		= {
 		.name	= "rcar-du",
 		.pm	= &rcar_du_pm_ops,
-- 
2.30.2

