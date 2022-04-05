Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704EC4F3111
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbiDEKb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239473AbiDEJdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED344CD4B;
        Tue,  5 Apr 2022 02:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99ABEB81B14;
        Tue,  5 Apr 2022 09:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDAEC385A2;
        Tue,  5 Apr 2022 09:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150531;
        bh=B8Q+cSPIOi/M5XObkjw1M58uMGbxfVaxxo5QHsotE6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eP8LCuz1ROxHspGMYnq3Sh9WD11QLFaZwia+dr1NjXtmrOWolNb7hH2/qSoec2D/
         um3IoZZ/SIXgIPikUokdo33VASGWAc3MmMXhgU4ymayVzGXu/cLQjGPbXx3Uthb/lD
         IpQDlm+7y6Zru0H23QycCbT35uBvBpCqYbTNuoZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Yonglin Tan <yonglin.tan@outlook.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 040/913] bus: mhi: pci_generic: Add mru_default for Quectel EM1xx series
Date:   Tue,  5 Apr 2022 09:18:22 +0200
Message-Id: <20220405070341.019068389@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Yonglin Tan <yonglin.tan@outlook.com>

commit 2413ffbf19a95cfcd7adf63135c5a9343a66d0a2 upstream.

For default mechanism, the driver uses default MRU 3500 if mru_default
is not initialized. The Qualcomm configured the MRU size to 32768 in the
WWAN device FW. So, we align the driver setting with Qualcomm FW setting.

Link: https://lore.kernel.org/r/MEYP282MB2374EE345DADDB591AFDA6AFFD2E9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM
Fixes: ac4bf60bbaa0 ("bus: mhi: pci_generic: Introduce quectel EM1XXGR-L support")
Cc: stable@vger.kernel.org
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Yonglin Tan <yonglin.tan@outlook.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20220301160308.107452-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -327,6 +327,7 @@ static const struct mhi_pci_dev_info mhi
 	.config = &modem_quectel_em1xx_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
+	.mru_default = 32768,
 	.sideband_wake = true,
 };
 


