Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19626364B5A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbhDSUoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242247AbhDSUoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0797461369;
        Mon, 19 Apr 2021 20:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865032;
        bh=fLGDTO4vZkaAfbFcATg/22G+9ZUgFi8xRlu4Z6L0ViQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVBM4lXDR+8lWY5rD7s8abE43vkM0aZnihlDtZMYnUeVyhAsFHCmPW01XG59gsz0p
         E3hEzlSMuLOnfcMU9xXi20FiWXX1vuw1spliVnlhCPOaviPCQy6oi+1WMomnE2oJl5
         SUYVtyucRrMYXsMdz2xnpD7Kkcybhk+EMkPfXm8Efangafqna4Cjlw7Cp2yOcZ8/a4
         lG8XIUQ09GB0FfGH9rh+iU3t1zNBagJ4yTpOTJK5klnTmO0bsDF9VlGbUpxgDoKQVE
         iI7jLKAfSYDYZp8qTdtofcFEahWeZorS1vd6DCnrhzDhOVIsuh7MydLSfWGbxHVB1x
         tyA9PXeg4uf1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 06/23] soc: qcom: geni: shield geni_icc_get() for ACPI boot
Date:   Mon, 19 Apr 2021 16:43:25 -0400
Message-Id: <20210419204343.6134-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 0c9fdcdba68208270ae85d39600ea97da1718344 ]

Currently, GENI devices like i2c-qcom-geni fails to probe in ACPI boot,
if interconnect support is enabled.  That's because interconnect driver
only supports DT right now.  As interconnect is not necessarily required
for basic function of GENI devices, let's shield geni_icc_get() call,
and then all other ICC calls become nop due to NULL icc_path, so that
GENI devices keep working for ACPI boot.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210114112928.11368-1-shawn.guo@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 1fd29f93ff6d..5bdfb1565c14 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -756,6 +756,9 @@ int geni_icc_get(struct geni_se *se, const char *icc_ddr)
 	int i, err;
 	const char *icc_names[] = {"qup-core", "qup-config", icc_ddr};
 
+	if (has_acpi_companion(se->dev))
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(se->icc_paths); i++) {
 		if (!icc_names[i])
 			continue;
-- 
2.30.2

