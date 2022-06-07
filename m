Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCDF540A73
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350810AbiFGST7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352295AbiFGSRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CB67CB5F;
        Tue,  7 Jun 2022 10:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDDA3B80B66;
        Tue,  7 Jun 2022 17:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A64C3411F;
        Tue,  7 Jun 2022 17:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624277;
        bh=kJXR8kpLFfhrZLiXgd/ouB1L9635f42zu5+kQo/mb2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uci5Du6eCHOaFEwPl49R8R6I1L2C01H+2UVKJEGKdoyKLX5nPDmJdryWyxJG5Eq0r
         /crgZm5HML5uwc4Pf66LBCs1mNFaFDtUqJxhgPEC2j13p4VqLtbHmeKzBROIOhe/Jo
         kBpGTSwrvhoWze/9lWW44Xbn7ygM1d0lHob2QIxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/667] drm/msm/dsi: fix error checks and return values for DSI xmit functions
Date:   Tue,  7 Jun 2022 18:58:55 +0200
Message-Id: <20220607164942.883315893@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f0e7e9ed379c012c4d6b09a09b868accc426223c ]

As noticed by Dan ([1] an the followup thread) there are multiple issues
with the return values for MSM DSI command transmission callback. In
the error case it can easily return a positive value when it should
have returned a proper error code.

This commits attempts to fix these issues both in TX and in RX paths.

[1]: https://lore.kernel.org/linux-arm-msm/20211001123617.GH2283@kili/

Fixes: a689554ba6ed ("drm/msm: Initial add DSI connector support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Tested-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/480501/
Link: https://lore.kernel.org/r/20220401231104.967193-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index eea679a52e86..eb60ce125a1f 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1375,10 +1375,10 @@ static int dsi_cmds2buf_tx(struct msm_dsi_host *msm_host,
 			dsi_get_bpp(msm_host->format) / 8;
 
 	len = dsi_cmd_dma_add(msm_host, msg);
-	if (!len) {
+	if (len < 0) {
 		pr_err("%s: failed to add cmd type = 0x%x\n",
 			__func__,  msg->type);
-		return -EINVAL;
+		return len;
 	}
 
 	/* for video mode, do not send cmds more than
@@ -1397,10 +1397,14 @@ static int dsi_cmds2buf_tx(struct msm_dsi_host *msm_host,
 	}
 
 	ret = dsi_cmd_dma_tx(msm_host, len);
-	if (ret < len) {
-		pr_err("%s: cmd dma tx failed, type=0x%x, data0=0x%x, len=%d\n",
-			__func__, msg->type, (*(u8 *)(msg->tx_buf)), len);
-		return -ECOMM;
+	if (ret < 0) {
+		pr_err("%s: cmd dma tx failed, type=0x%x, data0=0x%x, len=%d, ret=%d\n",
+			__func__, msg->type, (*(u8 *)(msg->tx_buf)), len, ret);
+		return ret;
+	} else if (ret < len) {
+		pr_err("%s: cmd dma tx failed, type=0x%x, data0=0x%x, ret=%d len=%d\n",
+			__func__, msg->type, (*(u8 *)(msg->tx_buf)), ret, len);
+		return -EIO;
 	}
 
 	return len;
@@ -2135,9 +2139,12 @@ int msm_dsi_host_cmd_rx(struct mipi_dsi_host *host,
 		}
 
 		ret = dsi_cmds2buf_tx(msm_host, msg);
-		if (ret < msg->tx_len) {
+		if (ret < 0) {
 			pr_err("%s: Read cmd Tx failed, %d\n", __func__, ret);
 			return ret;
+		} else if (ret < msg->tx_len) {
+			pr_err("%s: Read cmd Tx failed, too short: %d\n", __func__, ret);
+			return -ECOMM;
 		}
 
 		/*
-- 
2.35.1



