Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD27B4F27F8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiDEIJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbiDEH4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:56:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ED63F8A6;
        Tue,  5 Apr 2022 00:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ADDEB81B9C;
        Tue,  5 Apr 2022 07:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9A5C34110;
        Tue,  5 Apr 2022 07:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145044;
        bh=KMW3KVCvPXti6kTXH+XQzkBMTd9sHyzsbYOqLD1HiZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wijk1YeT2NgjycOQZsmXJWC+GESpLPvIRU0gBihTFR+BwPVJV2AsW5cXUPu95sqhL
         WK5KSUov2dC9I+zXbdYSoemA5NdyrxEvRMcB3rS9vJFsuVXmmfo5cubScB+HAlb9e4
         lSsrEIZZV64Yx2hsP3nAUTn9FqPLZ4VQVEb02kcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0215/1126] perf: MARVELL_CN10K_TAD_PMU should depend on ARCH_THUNDER
Date:   Tue,  5 Apr 2022 09:16:02 +0200
Message-Id: <20220405070413.919904828@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e564518b0727c8960942d8b1452703bbabf1a5ec ]

The Marvell CN10K Last-Level cache Tag-and-data Units (LLC-TAD)
performance monitor is only present on Marvell CN10K SoCs.  Hence add a
dependency on ARCH_THUNDER, to prevent asking the user about this driver
when configuring a kernel without Cavium Thunder (incl. Marvell CN10K)
SoC support.

Fixes: 036a7584bede ("drivers: perf: Add LLC-TAD perf counter support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/b4662a2c767d04cca19417e0c845edea2da262ad.1641995941.git.geert+renesas@glider.be
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
index e1a0c44bc686..7d6ffdf44a41 100644
--- a/drivers/perf/Kconfig
+++ b/drivers/perf/Kconfig
@@ -141,7 +141,7 @@ config ARM_DMC620_PMU
 
 config MARVELL_CN10K_TAD_PMU
 	tristate "Marvell CN10K LLC-TAD PMU"
-	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on ARCH_THUNDER || (COMPILE_TEST && 64BIT)
 	help
 	  Provides support for Last-Level cache Tag-and-data Units (LLC-TAD)
 	  performance monitors on CN10K family silicons.
-- 
2.34.1



