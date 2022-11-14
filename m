Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4AB62809A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbiKNNHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiKNNHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951D72AE05
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54721B80EC1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC944C433C1;
        Mon, 14 Nov 2022 13:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431235;
        bh=Myw+Wd4yLrOCyxO1Gdi3efhTJs5pY9boYOxaoI/Izto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4JL0S8IbfN+DBlL0rP9FksxIahuLS6vMSEhCtAZDw7gTIlfO4VqJ9LW4a22T3w8Y
         maT1Hm82jCM49AREihNzF56vaH4mxgRK/sTOYgKI9XuLp4qsammqvq41WodoPVlpfA
         ejEvE/txO4ZtixRODr6t+65KjBGkkfrrJ4c+OqeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 151/190] phy: qcom-qmp-combo: fix NULL-deref on runtime resume
Date:   Mon, 14 Nov 2022 13:46:15 +0100
Message-Id: <20221114124505.418202189@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 04948e757148f870a31f4887ea2239403f516c3c upstream.

Commit fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate
PCS_USB region") started treating the PCS_USB registers as potentially
separate from the PCS registers but used the wrong base when no PCS_USB
offset has been provided.

Fix the PCS_USB base used at runtime resume to prevent dereferencing a
NULL pointer on platforms that do not provide a PCS_USB offset (e.g.
SC7180).

Fixes: fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate PCS_USB region")
Cc: stable@vger.kernel.org	# 5.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20221026162116.26462-1-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1914,7 +1914,7 @@ static void qcom_qmp_phy_combo_enable_au
 static void qcom_qmp_phy_combo_disable_autonomous_mode(struct qmp_phy *qphy)
 {
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
-	void __iomem *pcs_usb = qphy->pcs_usb ?: qphy->pcs_usb;
+	void __iomem *pcs_usb = qphy->pcs_usb ?: qphy->pcs;
 	void __iomem *pcs_misc = qphy->pcs_misc;
 
 	/* Disable i/o clamp_n on resume for normal mode */


