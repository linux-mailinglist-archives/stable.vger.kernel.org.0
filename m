Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7EF69CE71
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjBTN72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbjBTN7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A8F1E9EF
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57EFD60E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C658C433EF;
        Mon, 20 Feb 2023 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901538;
        bh=WFWFEqbwYDhovhRzvINfurSA2RPOXvEef9O4DzZK0mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohT2UlaxgSAERcPjAlIYDc4z4Cwuna16dqwDFIQfId3IoR0oUdzYg8Um/q775DllS
         myoy4JHwwC2eFsfimvyhWIiTfIS0sVXxVH+HOZwnbgxIQw6QhlR+NfQVfyLL/Igwsj
         Ki0yJNyYOdliFogXUn3Ishm64S75Jox2LJvkmIXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Cercueil <paul@crapouillou.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 055/118] mmc: jz4740: Work around bug on JZ4760(B)
Date:   Mon, 20 Feb 2023 14:36:11 +0100
Message-Id: <20230220133602.654475729@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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
@@ -1053,6 +1053,16 @@ static int jz4740_mmc_probe(struct platf
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
 


