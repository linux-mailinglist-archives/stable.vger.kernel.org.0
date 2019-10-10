Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA7FD254B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbfJJI52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388292AbfJJIql (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:46:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C55E8208C3;
        Thu, 10 Oct 2019 08:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697201;
        bh=BpwReUT5upbxDY4KdUqv+Y7x6TYnxNaObYwjEsc7NMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMajZunKvHYCvlqhL1RmcFrFva9A85YbxehUfwR4VtocFGhhPPiUz9eRIzHDubpyf
         /gzqL3xfJ0dV09cghed/cjK+D/7m3Xa1RSvCf6O2B1iq9lHCAWsjbpF8D072zl+oXf
         chtU/zjemixCza9KXF+86qXnROy2UNCYxdif4Odo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 4.19 038/114] drm/msm/dsi: Fix return value check for clk_get_parent
Date:   Thu, 10 Oct 2019 10:35:45 +0200
Message-Id: <20191010083603.974508230@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

commit 5fb9b797d5ccf311ae4aba69e86080d47668b5f7 upstream.

clk_get_parent returns an error pointer upon failure, not NULL. So the
checks as they exist won't catch a failure. This patch changes the
checks and the return values to properly handle an error pointer.

Fixes: c4d8cfe516dc ("drm/msm/dsi: add implementation for helper functions")
Cc: Sibi Sankar <sibis@codeaurora.org>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Rob Clark <robdclark@chromium.org>
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/dsi/dsi_host.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -429,15 +429,15 @@ static int dsi_clk_init(struct msm_dsi_h
 	}
 
 	msm_host->byte_clk_src = clk_get_parent(msm_host->byte_clk);
-	if (!msm_host->byte_clk_src) {
-		ret = -ENODEV;
+	if (IS_ERR(msm_host->byte_clk_src)) {
+		ret = PTR_ERR(msm_host->byte_clk_src);
 		pr_err("%s: can't find byte_clk clock. ret=%d\n", __func__, ret);
 		goto exit;
 	}
 
 	msm_host->pixel_clk_src = clk_get_parent(msm_host->pixel_clk);
-	if (!msm_host->pixel_clk_src) {
-		ret = -ENODEV;
+	if (IS_ERR(msm_host->pixel_clk_src)) {
+		ret = PTR_ERR(msm_host->pixel_clk_src);
 		pr_err("%s: can't find pixel_clk clock. ret=%d\n", __func__, ret);
 		goto exit;
 	}


