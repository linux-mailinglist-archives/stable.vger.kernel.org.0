Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C74B4BD8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346110AbiBNKRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346365AbiBNKPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF4A88B37;
        Mon, 14 Feb 2022 01:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06F0A60F25;
        Mon, 14 Feb 2022 09:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CE9C340E9;
        Mon, 14 Feb 2022 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832364;
        bh=9/6JzC8Ei1Q6WqapUktg2s5rVzX9QnQZ38BxlY9Zk18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+aYc56KDo1JyJ8idVIX6iZbDukq1WqfHSibEoMXOLgMQIh53f62fHcwOC/t8OZAc
         X9+SkTJuj++rEZ+d75OJRhyZUImQnFvPi6jNd3vjjLiGMYlfss0CVGcy9BWEHwWStO
         6QugIpxJ0VWk0qt5mRL2WA5y8yZRm3OhBob7sdKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Slark Xiao <slark_xiao@163.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 162/172] bus: mhi: pci_generic: Add mru_default for Cinterion MV31-W
Date:   Mon, 14 Feb 2022 10:27:00 +0100
Message-Id: <20220214092511.985308494@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

commit 05daa805a86c831ad9692f6f15e1b877c8f10638 upstream.

For default mechanism, product would use default MRU 3500 if
they didn't define it. But for Cinterion MV31-W, there is a known
issue which MRU 3500 would lead to data connection lost.
So we align it with Qualcomm default MRU settings.

Link: https://lore.kernel.org/r/20220119102519.5342-1-slark_xiao@163.com
[mani: Modified the commit message to reflect Cinterion MV31-W and CCed stable]
Fixes: 87693e092bd0 ("bus: mhi: pci_generic: Add Cinterion MV31-W PCIe to MHI")
Cc: stable@vger.kernel.org # v5.14 +
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20220205135731.157871-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -402,6 +402,7 @@ static const struct mhi_pci_dev_info mhi
 	.config = &modem_mv31_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
+	.mru_default = 32768,
 };
 
 static const struct pci_device_id mhi_pci_id_table[] = {


