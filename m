Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC64F2825
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiDEIK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiDEH6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3074A76D6;
        Tue,  5 Apr 2022 00:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52E2EB81B90;
        Tue,  5 Apr 2022 07:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02BEC34110;
        Tue,  5 Apr 2022 07:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145163;
        bh=iWedxj7YTagci/gi3EDpl5fIirs9sNJC96Xu5blLHW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlMQGiIvJl95DezofkwY5Hn+hPNuduPhzsySkjwNeuoDsjGvMhP0olSMYImpMrCF5
         RIr3snBAlk+RF+rXv5VHTofNQZuWMak8FDXj0q+rcxg1te4axtOx/n3ORb2DkYhsSi
         82Zq8VvpkNIzby4p/IuMVZ60HbERscGizrcvdmYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0308/1126] memory: tegra20-emc: Correct memory device mask
Date:   Tue,  5 Apr 2022 09:17:35 +0200
Message-Id: <20220405070416.654889034@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 9ff684342ee7d3ea2755c6e9b60bc43085baa3ad ]

Memory chip select is swapped when we read mode register, correct it.
We didn't have devices that use a single LPDDR chip and both chips are
always identical, hence this change is just a minor improvement.

Fixes: 131dd9a436d8 ("memory: tegra20-emc: Support matching timings by LPDDR2 configuration")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211222043215.28237-2-digetx@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra20-emc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/tegra/tegra20-emc.c b/drivers/memory/tegra/tegra20-emc.c
index 497b6edbf3ca..25ba3c5e4ad6 100644
--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -540,7 +540,7 @@ static int emc_read_lpddr_mode_register(struct tegra_emc *emc,
 					unsigned int register_addr,
 					unsigned int *register_data)
 {
-	u32 memory_dev = emem_dev + 1;
+	u32 memory_dev = emem_dev ? 1 : 2;
 	u32 val, mr_mask = 0xff;
 	int err;
 
-- 
2.34.1



