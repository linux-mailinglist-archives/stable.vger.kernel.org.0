Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97BF560B3E1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiJXRTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiJXRTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:19:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63F0558F4;
        Mon, 24 Oct 2022 08:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDAEF61315;
        Mon, 24 Oct 2022 12:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB67CC433C1;
        Mon, 24 Oct 2022 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613656;
        bh=lMngYpEaHn+GSZ8B6h5KSHU2ZLlH+zvHYVzQIpHhrHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvLk25mr24WEVsR+QuIAaqj43TIuJrCx/IG0Yy1bU5rJFZ3AilO7ysiYfH0QyY+b+
         voO6kgWUkgNRW+lV8ZMDp98k0bR8y+6w1fXIu7zazfCzcSG3QGSKv6J20xdAjH21oH
         7miTMiktpmP9ztqmJl/TiZBASxfQBrH6GLpNbhYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Acayan <mailingradian@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/255] mmc: sdhci-msm: add compatible string check for sdm670
Date:   Mon, 24 Oct 2022 13:32:08 +0200
Message-Id: <20221024113010.317114540@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Acayan <mailingradian@gmail.com>

[ Upstream commit 4de95950d970c71a9e82a24573bb7a44fd95baa1 ]

The Snapdragon 670 has the same quirk as Snapdragon 845 (needing to
restore the dll config). Add a compatible string check to detect the need
for this.

Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220923014322.33620-3-mailingradian@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-msm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 8ab963055238..5e6f6c951fd4 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1755,6 +1755,7 @@ static const struct sdhci_msm_variant_info sdm845_sdhci_var = {
 static const struct of_device_id sdhci_msm_dt_match[] = {
 	{.compatible = "qcom,sdhci-msm-v4", .data = &sdhci_msm_mci_var},
 	{.compatible = "qcom,sdhci-msm-v5", .data = &sdhci_msm_v5_var},
+	{.compatible = "qcom,sdm670-sdhci", .data = &sdm845_sdhci_var},
 	{.compatible = "qcom,sdm845-sdhci", .data = &sdm845_sdhci_var},
 	{},
 };
-- 
2.35.1



