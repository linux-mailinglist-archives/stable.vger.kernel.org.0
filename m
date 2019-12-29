Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234E512C9D3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfL2R0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfL2R0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 827F821744;
        Sun, 29 Dec 2019 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640390;
        bh=ibYh33WcDqtJFx1fzZSI/8T3+GC6ZOgarCVSzWDpJsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6L4F+wdtG9hBqtMvW6Yc17i0LAyasqzmTx5jkPOsdy/lopzUGnuoqznDjvrXZMUs
         PJrKO/63NuWrl1G8Omba9ddy7bnTmnA4lhFnPbNIkc8S3aDCEDDuOKiEwFvcuTuuCC
         EBH/xKpWNeD8K4fhvih7UdYpGefbcv50ulqO/pdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaotian Jing <chaotian.jing@mediatek.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 139/161] mmc: mediatek: fix CMD_TA to 2 for MT8173 HS200/HS400 mode
Date:   Sun, 29 Dec 2019 18:19:47 +0100
Message-Id: <20191229162441.327994797@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaotian Jing <chaotian.jing@mediatek.com>

commit 8f34e5bd7024d1ffebddd82d7318b1be17be9e9a upstream.

there is a chance that always get response CRC error after HS200 tuning,
the reason is that need set CMD_TA to 2. this modification is only for
MT8173.

Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: stable@vger.kernel.org
Fixes: 1ede5cb88a29 ("mmc: mediatek: Use data tune for CMD line tune")
Link: https://lore.kernel.org/r/20191204071958.18553-1-chaotian.jing@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mtk-sd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -212,6 +212,8 @@
 #define MSDC_PATCH_BIT_SPCPUSH    (0x1 << 29)	/* RW */
 #define MSDC_PATCH_BIT_DECRCTMO   (0x1 << 30)	/* RW */
 
+#define MSDC_PATCH_BIT1_CMDTA     (0x7 << 3)    /* RW */
+
 #define MSDC_PAD_TUNE_DATWRDLY	  (0x1f <<  0)	/* RW */
 #define MSDC_PAD_TUNE_DATRRDLY	  (0x1f <<  8)	/* RW */
 #define MSDC_PAD_TUNE_CMDRDLY	  (0x1f << 16)  /* RW */
@@ -1442,6 +1444,7 @@ static int hs400_tune_response(struct mm
 
 	/* select EMMC50 PAD CMD tune */
 	sdr_set_bits(host->base + PAD_CMD_TUNE, BIT(0));
+	sdr_set_field(host->base + MSDC_PATCH_BIT1, MSDC_PATCH_BIT1_CMDTA, 2);
 
 	if (mmc->ios.timing == MMC_TIMING_MMC_HS200 ||
 	    mmc->ios.timing == MMC_TIMING_UHS_SDR104)


