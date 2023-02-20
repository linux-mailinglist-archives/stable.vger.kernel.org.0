Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2116D69CE2B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjBTN5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbjBTN45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:56:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA2B1E9E1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:56:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04F99B80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7F4C4339B;
        Mon, 20 Feb 2023 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901374;
        bh=93cCSeq00rS3kKJpXVdRqspW8MAzvrhLVMPqZfC9XrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRqEhH7qTbHFkV4CAQC9WhsHyeccQnmiY9ZTLagZ7aM/69rASxxnXjdXyrX7iJHH6
         XOmtQvsELNKl4dDK1lKPuJAWkRHObMZu59J6M9KK3vk4tzwq+zbH/ceZWnly5T61B/
         Ww6cgFNy0faUV3dLe7zMpmCSFvL7OHkyli0KkkTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Cercueil <paul@crapouillou.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 21/57] mmc: jz4740: Work around bug on JZ4760(B)
Date:   Mon, 20 Feb 2023 14:36:29 +0100
Message-Id: <20230220133550.099182379@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 3f18c5046e633cc4bbad396b74c05d46d353033d upstream.

On JZ4760 and JZ4760B, SD cards fail to run if the maximum clock
rate is set to 50 MHz, even though the controller officially does
support it.

Until the actual bug is found and fixed, limit the maximum clock rate to
24 MHz.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230131210229.68129-1-paul@crapouillou.net
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/jz4740_mmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1041,6 +1041,16 @@ static int jz4740_mmc_probe(struct platf
 	mmc->ops = &jz4740_mmc_ops;
 	if (!mmc->f_max)
 		mmc->f_max = JZ_MMC_CLK_RATE;
+
+	/*
+	 * There seems to be a problem with this driver on the JZ4760 and
+	 * JZ4760B SoCs. There, when using the maximum rate supported (50 MHz),
+	 * the communication fails with many SD cards.
+	 * Until this bug is sorted out, limit the maximum rate to 24 MHz.
+	 */
+	if (host->version == JZ_MMC_JZ4760 && mmc->f_max > JZ_MMC_CLK_RATE)
+		mmc->f_max = JZ_MMC_CLK_RATE;
+
 	mmc->f_min = mmc->f_max / 128;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 


