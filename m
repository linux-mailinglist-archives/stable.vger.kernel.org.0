Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532464F352C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343635AbiDEI5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242362AbiDEIhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE9C1CFF7;
        Tue,  5 Apr 2022 01:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 719796117D;
        Tue,  5 Apr 2022 08:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEA3C385A0;
        Tue,  5 Apr 2022 08:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147561;
        bh=B8Q+cSPIOi/M5XObkjw1M58uMGbxfVaxxo5QHsotE6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNjpU4r4xnw3wB1AGK46MI/Pf+nu6YlizKrUKJxUGAMKkitgHU5uDS5eIYrNXECCw
         1Xc39m8Vq0UDXKRp/BLHXugt0fBN2BPFdvdxs6EKdZd+a0lyQeBdUVmjodc0hqQWK8
         +dFC94BSVsdR2wElA94DELUmUYLkQFtbFYsShiyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Yonglin Tan <yonglin.tan@outlook.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.16 0041/1017] bus: mhi: pci_generic: Add mru_default for Quectel EM1xx series
Date:   Tue,  5 Apr 2022 09:15:54 +0200
Message-Id: <20220405070355.399862618@linuxfoundation.org>
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
 


