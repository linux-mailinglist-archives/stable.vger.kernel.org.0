Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB1C37C8D0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhELQNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239147AbhELQH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E88C613FB;
        Wed, 12 May 2021 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833786;
        bh=7XwtRKaT9fbjGtJQVoWtOUiOvNV40pTl1acFZTm8aQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWbBxUTtysBkjBwT/7nkRTqwVTlkwVQqkp/UBIlU9czjnM1npwjUYMhs0/1ZdrB4j
         TZMhxbJWKSDK16EjArvuohBQC23rVNzQH28nuHoeFKR3Kqi5nT1Bas0Le54HUN+6mq
         Q7moyhGqDMA0/O45slrVlA5rmZ+6Mwfp8S13fTdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 287/601] memory: samsung: exynos5422-dmc: handle clk_set_parent() failure
Date:   Wed, 12 May 2021 16:46:04 +0200
Message-Id: <20210512144837.255608090@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 132c17c3ff878c7beaba51bdd275d5cc654c0e33 ]

clk_set_parent() can fail and ignoring such case could lead to invalid
clock setup for given frequency.

Addresses-Coverity: Unchecked return value
Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://lore.kernel.org/r/20210407154535.70756-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/samsung/exynos5422-dmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index c5ee4121a4d2..3d230f07eaf2 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1298,7 +1298,9 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
 
 	dmc->curr_volt = target_volt;
 
-	clk_set_parent(dmc->mout_mx_mspll_ccore, dmc->mout_spll);
+	ret = clk_set_parent(dmc->mout_mx_mspll_ccore, dmc->mout_spll);
+	if (ret)
+		return ret;
 
 	clk_prepare_enable(dmc->fout_bpll);
 	clk_prepare_enable(dmc->mout_bpll);
-- 
2.30.2



