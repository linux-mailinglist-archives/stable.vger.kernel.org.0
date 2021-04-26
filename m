Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2F936AE5F
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhDZHoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233671AbhDZHnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:43:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B67E613BA;
        Mon, 26 Apr 2021 07:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422774;
        bh=P20kHEYm4uUCgh052ecN3NDKkwWJw8kGBA9GgpWC6HE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSiO0v1Y82pvP8oxEfRmMzNND7DUnvPbkHy2qoK0APUZeYQUZTFyDGPeYalZxDXdQ
         yATSFXPoh1nmXUGDi4QuTmTTZShrWe/H1bz5BiQa2sgr5hdYBSoOhixumWZXhYUlWR
         pmVuMTisVX89xhhF29fceHlx/vt5IhiUmQdMUj8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/36] soc: qcom: geni: shield geni_icc_get() for ACPI boot
Date:   Mon, 26 Apr 2021 09:30:04 +0200
Message-Id: <20210426072819.548695474@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index be76fddbf524..0dbca679bd32 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -741,6 +741,9 @@ int geni_icc_get(struct geni_se *se, const char *icc_ddr)
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



