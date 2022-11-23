Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17FC635744
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238042AbiKWJjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237962AbiKWJjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:39:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476AF114486
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:37:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC58EB81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071ABC433D7;
        Wed, 23 Nov 2022 09:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196218;
        bh=EKZ4cdmEZz25H9XGgwx9cNIJnnHiTuH/vUNa9qb7MUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5sNTm1xtP4EdRSTH5pxgSbcPk/yDl+0HcsaZfQC5NU/PlsnCe9XSPm/Es/cmHxiK
         Y5uHPqX5fcCb91hX6TfXpfYCmvavUo0wu9SZQCF575bW0zmXSf6RG6/rxOtFDsC4tU
         mGS0jVkG1s9LgGk7vr3E081iWBMarYpaEjyEjANA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chevron Li <chevron.li@bayhubtech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 152/181] mmc: sdhci-pci-o2micro: fix card detect fail issue caused by CD# debounce timeout
Date:   Wed, 23 Nov 2022 09:51:55 +0100
Message-Id: <20221123084608.915508900@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chevron Li <chevron.li@bayhubtech.com>

commit 096cc0cddf58232bded309336961784f1d1c85f8 upstream.

The SD card is recognized failed sometimes when resume from suspend.
Because CD# debounce time too long then card present report wrong.
Finally, card is recognized failed.

Signed-off-by: Chevron Li <chevron.li@bayhubtech.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221104095512.4068-1-chevron.li@bayhubtech.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-o2micro.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -31,6 +31,7 @@
 #define O2_SD_CAPS		0xE0
 #define O2_SD_ADMA1		0xE2
 #define O2_SD_ADMA2		0xE7
+#define O2_SD_MISC_CTRL2	0xF0
 #define O2_SD_INF_MOD		0xF1
 #define O2_SD_MISC_CTRL4	0xFC
 #define O2_SD_MISC_CTRL		0x1C0
@@ -830,6 +831,12 @@ static int sdhci_pci_o2_probe(struct sdh
 		/* Set Tuning Windows to 5 */
 		pci_write_config_byte(chip->pdev,
 				O2_SD_TUNING_CTRL, 0x55);
+		//Adjust 1st and 2nd CD debounce time
+		pci_read_config_dword(chip->pdev, O2_SD_MISC_CTRL2, &scratch_32);
+		scratch_32 &= 0xFFE7FFFF;
+		scratch_32 |= 0x00180000;
+		pci_write_config_dword(chip->pdev, O2_SD_MISC_CTRL2, scratch_32);
+		pci_write_config_dword(chip->pdev, O2_SD_DETECT_SETTING, 1);
 		/* Lock WP */
 		ret = pci_read_config_byte(chip->pdev,
 					   O2_SD_LOCK_WP, &scratch);


