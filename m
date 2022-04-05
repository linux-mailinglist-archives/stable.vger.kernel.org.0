Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342164F280C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiDEIKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiDEICD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8DE49FB3;
        Tue,  5 Apr 2022 01:00:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76066B81B16;
        Tue,  5 Apr 2022 08:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6284C340EE;
        Tue,  5 Apr 2022 08:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145603;
        bh=zNbstIO7fTReljmVQ05A1unZPeHQpqkHrt0QzvkAAfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12WtbljeNdb4uRS9U1cFjunzmCpAXBKc6gyAsQ8HPPUAnTYdyYmc548dbpAzCV1zW
         mJFS+jlg/Q8ZsrHwOmx0ecj/+htiGU+iZjS2rmNHmL5u0b3+8oXFO0bLT0bY2Rvpxs
         KdGRAWPTpNylaU9JetuHlme0vGT/dRg7IwiC4kFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0426/1126] drm/bridge: Add missing pm_runtime_disable() in __dw_mipi_dsi_probe
Date:   Tue,  5 Apr 2022 09:19:33 +0200
Message-Id: <20220405070420.129574971@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 96211b7c56b109a52768e6cc5e23a1f79316eca0 ]

If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().
Add missing pm_runtime_disable() for __dw_mipi_dsi_probe.

Fixes: 46fc51546d44 ("drm/bridge/synopsys: Add MIPI DSI host controller bridge")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220105104113.31415-1-linmq006@gmail.com
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c b/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
index e44e18a0112a..56c3fd08c6a0 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c
@@ -1199,6 +1199,7 @@ __dw_mipi_dsi_probe(struct platform_device *pdev,
 	ret = mipi_dsi_host_register(&dsi->dsi_host);
 	if (ret) {
 		dev_err(dev, "Failed to register MIPI host: %d\n", ret);
+		pm_runtime_disable(dev);
 		dw_mipi_dsi_debugfs_remove(dsi);
 		return ERR_PTR(ret);
 	}
-- 
2.34.1



