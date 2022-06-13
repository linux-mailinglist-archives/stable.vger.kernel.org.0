Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A86549858
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381204AbiFMOKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381788AbiFMOJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:09:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08969874C;
        Mon, 13 Jun 2022 04:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC266124E;
        Mon, 13 Jun 2022 11:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDF0C34114;
        Mon, 13 Jun 2022 11:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120496;
        bh=c2aNa0WSTPINaaEVfNO7vaNrky3Fd5u8zr9Pepbdaso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQtP73c1VlWG+EREaALQqehDRnKzwT5U1EpAF7RR4Yc3AU6hsuzihnhK/rzsbAtgB
         3mDKFPdifFSb6y59oxinopNxhH6VykxqwmqgKKcJl3ESnoPWfGiFPV2ENAWLP4BoKC
         7vANL9F1EyV75PxZAv65TaMIjSGIjAFt97KXpGIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 036/298] phy: qcom-qmp: fix pipe-clock imbalance on power-on failure
Date:   Mon, 13 Jun 2022 12:08:50 +0200
Message-Id: <20220613094926.028502004@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index c2b878128e2c..7493fd634c1d 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5246,7 +5246,7 @@ static int qcom_qmp_phy_power_on(struct phy *phy)
 
 	ret = reset_control_deassert(qmp->ufs_reset);
 	if (ret)
-		goto err_lane_rst;
+		goto err_pcs_ready;
 
 	qcom_qmp_phy_configure(pcs_misc, cfg->regs, cfg->pcs_misc_tbl,
 			       cfg->pcs_misc_tbl_num);
-- 
2.35.1



