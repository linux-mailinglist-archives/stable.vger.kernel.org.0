Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FFC4A41D0
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358515AbiAaLGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:06:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52380 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348720AbiAaLE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:04:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 195CFB82A6A;
        Mon, 31 Jan 2022 11:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF9DC340E8;
        Mon, 31 Jan 2022 11:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627066;
        bh=yvLfEvfM1S9QsM+cfwQvHnI2a+N1nMMw0orbNRBlg70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OalX7TuzZJS31C/q0j6S7L0y2RdnmoERvSVQ/ZcCONrD044hb/6JSMFxeyv0/9hSI
         H98xKYv1RVAgDMwkkiWDWk4mKM9piNDYmYJaO8GDzHKl8Fq2Ne/Exy5b5FyUOud7n8
         CGD7xe+GCnBzgonBZqFCuUxdEB5rsdcRNlb0xv70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 063/100] drm/msm/dsi: Fix missing put_device() call in dsi_get_phy
Date:   Mon, 31 Jan 2022 11:56:24 +0100
Message-Id: <20220131105222.554006644@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit c04c3148ca12227d92f91b355b4538cc333c9922 upstream.

If of_find_device_by_node() succeeds, dsi_get_phy() doesn't
a corresponding put_device(). Thus add put_device() to fix the exception
handling.

Fixes: ec31abf ("drm/msm/dsi: Separate PHY to another platform device")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211230070943.18116-1-linmq006@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/dsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -33,7 +33,12 @@ static int dsi_get_phy(struct msm_dsi *m
 
 	of_node_put(phy_node);
 
-	if (!phy_pdev || !msm_dsi->phy) {
+	if (!phy_pdev) {
+		DRM_DEV_ERROR(&pdev->dev, "%s: phy driver is not ready\n", __func__);
+		return -EPROBE_DEFER;
+	}
+	if (!msm_dsi->phy) {
+		put_device(&phy_pdev->dev);
 		DRM_DEV_ERROR(&pdev->dev, "%s: phy driver is not ready\n", __func__);
 		return -EPROBE_DEFER;
 	}


