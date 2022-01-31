Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C704A415F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348729AbiAaLDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359135AbiAaLDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:03:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AE1C06137E;
        Mon, 31 Jan 2022 03:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAC4660B2D;
        Mon, 31 Jan 2022 11:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA68C340E8;
        Mon, 31 Jan 2022 11:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626886;
        bh=yvLfEvfM1S9QsM+cfwQvHnI2a+N1nMMw0orbNRBlg70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3AnDFXea3VB0ZgIy8XR6MIY8RmJM4jChf/nrWFisqMF8GoiCr9WxrvEU1Iz9loz1
         Q1n5OiDU2aX/KczyuxjtZ60tXcEsWAp6t4AN7FVddatqtxH2H4iEigOch0tEH3b+rH
         pSCCu3HCasAnTqjGlw/UAs1pIW1f2WBWmvhVKOxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.4 44/64] drm/msm/dsi: Fix missing put_device() call in dsi_get_phy
Date:   Mon, 31 Jan 2022 11:56:29 +0100
Message-Id: <20220131105217.168931203@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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


