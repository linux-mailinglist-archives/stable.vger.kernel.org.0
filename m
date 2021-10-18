Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601A7431B8F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhJRNdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhJRNcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A07B61361;
        Mon, 18 Oct 2021 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563739;
        bh=ZGzhGwbdTu8vn5Z0RtLJ+mH04prsIESewSKx1xJlvhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6sYubtT9ZTFuVnRdZtT3GemraEIfjTYjZli1ozXooyKniv6dVYiGQ+NVZnKoq/+S
         cAQqRU2RTaevsOOTH1kagIOGgSxl3QkI5UnvJTHjnhBkYvESgD42yo7hVKbbvbQrYV
         j34g1emmPUEhtHQN/WcH7L/mprFySWEm18E5k4X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 4.19 45/50] drm/msm/dsi: Fix an error code in msm_dsi_modeset_init()
Date:   Mon, 18 Oct 2021 15:24:52 +0200
Message-Id: <20211018132328.013908324@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 739b4e7756d3301dd673ca517afca46a5f635562 upstream.

Return an error code if msm_dsi_manager_validate_current_config().
Don't return success.

Fixes: 8b03ad30e314 ("drm/msm/dsi: Use one connector for dual DSI mode")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211001123308.GF2283@kili
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/dsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -208,8 +208,10 @@ int msm_dsi_modeset_init(struct msm_dsi
 		goto fail;
 	}
 
-	if (!msm_dsi_manager_validate_current_config(msm_dsi->id))
+	if (!msm_dsi_manager_validate_current_config(msm_dsi->id)) {
+		ret = -EINVAL;
 		goto fail;
+	}
 
 	msm_dsi->encoder = encoder;
 


