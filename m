Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F1254912A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354655AbiFMMzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357836AbiFMMyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCD966692;
        Mon, 13 Jun 2022 04:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE463B80D31;
        Mon, 13 Jun 2022 11:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13363C34114;
        Mon, 13 Jun 2022 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118807;
        bh=FPCtJIGId+3o2cgwL1VcU2bSODXmShM9hQCM1twwlq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lp6kRZPdJOkKSvpUK5+uvGmoGE+Oidyk6tz6Q9p5jfIT1EdTizSfymAObMqFnj9Br
         j8yaBWoIzEXHL3TGIxkPpX0z5MpFoD5exie7CaXwzQIqxiQcZcdXjNNcT8smziWJcb
         VrZdkFs4OPHzW+h/i4fUOZ4Y0MV+Dq0M3xv7xyc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/247] phy: qcom-qmp: fix pipe-clock imbalance on power-on failure
Date:   Mon, 13 Jun 2022 12:08:57 +0200
Message-Id: <20220613094924.002277108@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 5e73b2d9867998278479ccc065a8a8227a5513ef ]

Make sure to disable the pipe clock also if ufs-reset deassertion fails
during power on.

Note that the ufs-reset is asserted in qcom_qmp_phy_com_exit().

Fixes: c9b589791fc1 ("phy: qcom: Utilize UFS reset controller")
Cc: Evan Green <evgreen@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220502133130.4125-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 9bb19c4bfe79..ed69d455ac0e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -4802,7 +4802,7 @@ static int qcom_qmp_phy_power_on(struct phy *phy)
 
 	ret = reset_control_deassert(qmp->ufs_reset);
 	if (ret)
-		goto err_lane_rst;
+		goto err_pcs_ready;
 
 	qcom_qmp_phy_configure(pcs_misc, cfg->regs, cfg->pcs_misc_tbl,
 			       cfg->pcs_misc_tbl_num);
-- 
2.35.1



