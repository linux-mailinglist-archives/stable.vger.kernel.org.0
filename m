Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C79F404AD5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbhIILtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240829AbhIILqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 313C06124D;
        Thu,  9 Sep 2021 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187780;
        bh=JCUyILyV+6ACnUJ0rjVdIkqYyZqashxOxCmyeCo/XRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AntwiYDacIqm8tgjvmMtijk0hFSM91A5fwSDR3tmGsUcpPPKBPDAKMjq470YBxkIU
         52UemGmQ3/OoAuwdZJEqhK+osES+dTCldmfNIsIId1+TAea2GkkFJtG4OxmTpzgD65
         Ke8WAH065j3hZD4kB/3SaHSOkw4/sQr43hPNnO91H9AcvbQwA2c0SY8zqOrfQI+evE
         RrF/qFTQiJdEwqVZ50vOQru2m8kyM8OCPB/ZFwrYsb//RDDNGuiB+z1htHs4rARJ9K
         yUhS8ffr2WINrIlMKbM2qTiVOMqlk38LpIWNlCRswafud5S3rkNtPF2QvHEaU7HpSB
         zF96JRd8MpEZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 089/252] drm: rcar-du: Shutdown the display on system shutdown
Date:   Thu,  9 Sep 2021 07:38:23 -0400
Message-Id: <20210909114106.141462-89-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

