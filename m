Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1548C6AF284
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbjCGSxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbjCGSxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:53:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC916AF0C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8961CB819CB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B85C433D2;
        Tue,  7 Mar 2023 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214462;
        bh=/VOYS5xwVDhIWJkey/rUzl/YEKnYN6PZoTXll3g8k0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wvb2JVIAwZGIaAIs1pI629sfQIyJGFxBKicxM2iVekamKVuuUpaioDkb1L3Sfp/Bu
         kalEkJFvNTm1jfYdg24m7vTzeyGERTr4TzlW8SLIwEPryvM1XD9Q/gTtL9KrTqATJ/
         eL+cWQKqSJHgTtbC/fK9XUFh1m1nWip0eIHqZOiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 829/885] remoteproc/mtk_scp: Move clk ops outside send_lock
Date:   Tue,  7 Mar 2023 18:02:43 +0100
Message-Id: <20230307170037.869371135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit e46ceea3148163166ef9b7bcac578e72dd30c064 upstream.

Clocks are properly reference counted and do not need to be inside the
lock range.

Right now this triggers a false-positive lockdep warning on MT8192 based
Chromebooks, through a combination of mtk-scp that has a cros-ec-rpmsg
sub-device, the (actual) cros-ec I2C adapter registration, I2C client
(not on cros-ec) probe doing i2c transfers and enabling clocks.

This is a false positive because the cros-ec-rpmsg under mtk-scp does
not have an I2C adapter, and also each I2C adapter and cros-ec instance
have their own mutex.

Move the clk operations outside of the send_lock range.

Fixes: 63c13d61eafe ("remoteproc/mediatek: add SCP support for mt8183")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230104083110.736377-1-wenst@chromium.org
[Fixed "Fixes:" tag line]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/mtk_scp_ipi.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/remoteproc/mtk_scp_ipi.c
+++ b/drivers/remoteproc/mtk_scp_ipi.c
@@ -164,21 +164,21 @@ int scp_ipi_send(struct mtk_scp *scp, u3
 	    WARN_ON(len > sizeof(send_obj->share_buf)) || WARN_ON(!buf))
 		return -EINVAL;
 
-	mutex_lock(&scp->send_lock);
-
 	ret = clk_prepare_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clock\n");
-		goto unlock_mutex;
+		return ret;
 	}
 
+	mutex_lock(&scp->send_lock);
+
 	 /* Wait until SCP receives the last command */
 	timeout = jiffies + msecs_to_jiffies(2000);
 	do {
 		if (time_after(jiffies, timeout)) {
 			dev_err(scp->dev, "%s: IPI timeout!\n", __func__);
 			ret = -ETIMEDOUT;
-			goto clock_disable;
+			goto unlock_mutex;
 		}
 	} while (readl(scp->reg_base + scp->data->host_to_scp_reg));
 
@@ -205,10 +205,9 @@ int scp_ipi_send(struct mtk_scp *scp, u3
 			ret = 0;
 	}
 
-clock_disable:
-	clk_disable_unprepare(scp->clk);
 unlock_mutex:
 	mutex_unlock(&scp->send_lock);
+	clk_disable_unprepare(scp->clk);
 
 	return ret;
 }


