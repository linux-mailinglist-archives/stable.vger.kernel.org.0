Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5D04F2E12
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbiDEJMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244833AbiDEIwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B2022512;
        Tue,  5 Apr 2022 01:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 415E5CE1C6D;
        Tue,  5 Apr 2022 08:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58907C385A0;
        Tue,  5 Apr 2022 08:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148268;
        bh=iWedxj7YTagci/gi3EDpl5fIirs9sNJC96Xu5blLHW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNY1v7BuWUWRVYEMOtiB/QNDzRqXnF9xXL/PtY8yBPGG/sBN5Wn3J7Ev0GC8CKCMi
         a6jshQd6MuiA2PMycfFgWi0fWYJowOGR1wPuR4IKy8vb/DEBtqL9XxrBGlRvl78ziQ
         lTcv1ZaPwwh6FoMOGOLwu6qzNuLPTQddCiQmXmsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0294/1017] memory: tegra20-emc: Correct memory device mask
Date:   Tue,  5 Apr 2022 09:20:07 +0200
Message-Id: <20220405070403.001122645@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



