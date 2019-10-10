Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7042D25B0
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbfJJIkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387493AbfJJIka (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9749720B7C;
        Thu, 10 Oct 2019 08:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696830;
        bh=AYCAce8R8+1AGpgdpdakmyUkNlhCjR6dQ3fDZMXkhHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4+fRh/t7nN9GpBhYpv1raWa92g8DzlzxFv3WoiUFp6yHeeYOPvO1EJq5k/kZBtGB
         QEcWZRLI4jWVqQiu+Urz6mEea64I7hEP5ucrIgW1ZoFSfkdatUGPzt99opcTnDqU+t
         zWQewcrtARCMHnhE8GZtRUJGZ/N8CfCmz0LHs+sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.3 067/148] drm/msm/dsi: Fix return value check for clk_get_parent
Date:   Thu, 10 Oct 2019 10:35:28 +0200
Message-Id: <20191010083615.502085657@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
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
@@ -421,15 +421,15 @@ static int dsi_clk_init(struct msm_dsi_h
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


