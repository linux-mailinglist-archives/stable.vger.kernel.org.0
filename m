Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C196ECE34
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjDXNaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbjDXNaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:30:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D802769F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C6DB62322
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD1FC433D2;
        Mon, 24 Apr 2023 13:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342987;
        bh=7pMFKFDJI+sG7ctg5O1lzusZkdcpTqN1n1aWhh1mVIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuYCCCoKm6NXDj5kclLV4JRBs8wuNUM/ZZfe3Gf50abeFHp2drHhwO+owobOx6t46
         YdNWuAHxdlWFtqKHLtPqpzL7h+xBTErXxMhK1LBTxE64hEAIG3/k4LvCzCUBxhgz9Y
         aifwHjGcF2+jH/sYTNmCsY4SFV/VVAJf8tLXReUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Gonzalez <mgonzalez@freebox.fr>,
        Will Deacon <will@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 007/110] perf/amlogic: adjust register offsets
Date:   Mon, 24 Apr 2023 15:16:29 +0200
Message-Id: <20230424131136.406932947@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit f9d323e7c1724270d747657051099826744e91e7 ]

Commit "perf/amlogic: resolve conflict between canvas & pmu"
changed the base address.

Fixes: 2016e2113d35 ("perf/amlogic: Add support for Amlogic meson G12 SoC DDR PMU driver")
Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230327120932.2158389-4-mgonzalez@freebox.fr
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/amlogic/meson_g12_ddr_pmu.c | 34 ++++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/perf/amlogic/meson_g12_ddr_pmu.c b/drivers/perf/amlogic/meson_g12_ddr_pmu.c
index a78fdb15e26c2..8b643888d5036 100644
--- a/drivers/perf/amlogic/meson_g12_ddr_pmu.c
+++ b/drivers/perf/amlogic/meson_g12_ddr_pmu.c
@@ -21,23 +21,23 @@
 #define DMC_QOS_IRQ		BIT(30)
 
 /* DMC bandwidth monitor register address offset */
-#define DMC_MON_G12_CTRL0		(0x20  << 2)
-#define DMC_MON_G12_CTRL1		(0x21  << 2)
-#define DMC_MON_G12_CTRL2		(0x22  << 2)
-#define DMC_MON_G12_CTRL3		(0x23  << 2)
-#define DMC_MON_G12_CTRL4		(0x24  << 2)
-#define DMC_MON_G12_CTRL5		(0x25  << 2)
-#define DMC_MON_G12_CTRL6		(0x26  << 2)
-#define DMC_MON_G12_CTRL7		(0x27  << 2)
-#define DMC_MON_G12_CTRL8		(0x28  << 2)
-
-#define DMC_MON_G12_ALL_REQ_CNT		(0x29  << 2)
-#define DMC_MON_G12_ALL_GRANT_CNT	(0x2a  << 2)
-#define DMC_MON_G12_ONE_GRANT_CNT	(0x2b  << 2)
-#define DMC_MON_G12_SEC_GRANT_CNT	(0x2c  << 2)
-#define DMC_MON_G12_THD_GRANT_CNT	(0x2d  << 2)
-#define DMC_MON_G12_FOR_GRANT_CNT	(0x2e  << 2)
-#define DMC_MON_G12_TIMER		(0x2f  << 2)
+#define DMC_MON_G12_CTRL0		(0x0  << 2)
+#define DMC_MON_G12_CTRL1		(0x1  << 2)
+#define DMC_MON_G12_CTRL2		(0x2  << 2)
+#define DMC_MON_G12_CTRL3		(0x3  << 2)
+#define DMC_MON_G12_CTRL4		(0x4  << 2)
+#define DMC_MON_G12_CTRL5		(0x5  << 2)
+#define DMC_MON_G12_CTRL6		(0x6  << 2)
+#define DMC_MON_G12_CTRL7		(0x7  << 2)
+#define DMC_MON_G12_CTRL8		(0x8  << 2)
+
+#define DMC_MON_G12_ALL_REQ_CNT		(0x9  << 2)
+#define DMC_MON_G12_ALL_GRANT_CNT	(0xa  << 2)
+#define DMC_MON_G12_ONE_GRANT_CNT	(0xb  << 2)
+#define DMC_MON_G12_SEC_GRANT_CNT	(0xc  << 2)
+#define DMC_MON_G12_THD_GRANT_CNT	(0xd  << 2)
+#define DMC_MON_G12_FOR_GRANT_CNT	(0xe  << 2)
+#define DMC_MON_G12_TIMER		(0xf  << 2)
 
 /* Each bit represent a axi line */
 PMU_FORMAT_ATTR(event, "config:0-7");
-- 
2.39.2



