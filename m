Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4E540CF5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349651AbiFGSmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353504AbiFGSlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:41:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2F45C87E;
        Tue,  7 Jun 2022 10:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3B7161680;
        Tue,  7 Jun 2022 17:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4063C385A5;
        Tue,  7 Jun 2022 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624728;
        bh=iLP3JKq+6tc3Xe12H49Dx6ol4z6cCangnxLnLXsDDbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aefhhWiVNizLG4S/cNpNi3tY9Bv2hrC3MND7rHpbVDU0SILRo4ff+PiZcvxcnplsf
         76GrshJRRC40VrKo0i91lH7au1g0vlV36UlBbfd0IsP3wQIJ5eqwq3ASvBRQm2HhYk
         /1XeVbIGOKP3Bzd3MDdPs1n4vj4q+CyryfLfDHiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/667] soc: qcom: llcc: Add MODULE_DEVICE_TABLE()
Date:   Tue,  7 Jun 2022 19:01:00 +0200
Message-Id: <20220607164946.593070525@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 5334a3b12a7233b31788de60d61bfd890059d783 ]

The llcc-qcom driver can be compiled as a module, but lacks
MODULE_DEVICE_TABLE() and will therefore not be loaded automatically.
Fix this.

Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220408213336.581661-3-bjorn.andersson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index e53109a5c3da..cabd8870316d 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -630,6 +630,7 @@ static const struct of_device_id qcom_llcc_of_match[] = {
 	{ .compatible = "qcom,sm8250-llcc", .data = &sm8250_cfg },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, qcom_llcc_of_match);
 
 static struct platform_driver qcom_llcc_driver = {
 	.driver = {
-- 
2.35.1



