Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37A66810D4
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbjA3OHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbjA3OHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:07:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01D53B641
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3983F61083
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347BEC433EF;
        Mon, 30 Jan 2023 14:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087628;
        bh=sx80RY1j1NA+28Zxc/ujMkWRNWUMKpnPcPs4BqBBH0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0W0+LAsXtkjztH/FmFlH6BeV0PzjdJPBEr7KQdHyZy5ZSy0MBs2n8U/PmDSy2HNj
         At2OdUg+79VLVrUgblAV0U4QKjm9u+ZvXQtdGteKUAhL+OEzZ31tu8MJ8Xy+f5BKtd
         9tjVSYmUeSllinBMEXjRusXhx437JgkhpzIpC7ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steev Klimaszewski <steev@kali.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.1 232/313] EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_infos pvt_info
Date:   Mon, 30 Jan 2023 14:51:07 +0100
Message-Id: <20230130134347.521188374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 977c6ba624f24ae20cf0faee871257a39348d4a9 upstream.

The memory for llcc_driv_data is allocated by the LLCC driver. But when
it is passed as the private driver info to the EDAC core, it will get freed
during the qcom_edac driver release. So when the qcom_edac driver gets probed
again, it will try to use the freed data leading to the use-after-free bug.

Hence, do not pass llcc_driv_data as pvt_info but rather reference it
using the platform_data pointer in the qcom_edac driver.

Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
Reported-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Steev Klimaszewski <steev@kali.org> # Thinkpad X13s
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8540p-ride
Cc: <stable@vger.kernel.org> # 4.20
Link: https://lore.kernel.org/r/20230118150904.26913-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/qcom_edac.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/edac/qcom_edac.c
+++ b/drivers/edac/qcom_edac.c
@@ -252,7 +252,7 @@ clear:
 static int
 dump_syn_reg(struct edac_device_ctl_info *edev_ctl, int err_type, u32 bank)
 {
-	struct llcc_drv_data *drv = edev_ctl->pvt_info;
+	struct llcc_drv_data *drv = edev_ctl->dev->platform_data;
 	int ret;
 
 	ret = dump_syn_reg_values(drv, bank, err_type);
@@ -289,7 +289,7 @@ static irqreturn_t
 llcc_ecc_irq_handler(int irq, void *edev_ctl)
 {
 	struct edac_device_ctl_info *edac_dev_ctl = edev_ctl;
-	struct llcc_drv_data *drv = edac_dev_ctl->pvt_info;
+	struct llcc_drv_data *drv = edac_dev_ctl->dev->platform_data;
 	irqreturn_t irq_rc = IRQ_NONE;
 	u32 drp_error, trp_error, i;
 	int ret;
@@ -358,7 +358,6 @@ static int qcom_llcc_edac_probe(struct p
 	edev_ctl->dev_name = dev_name(dev);
 	edev_ctl->ctl_name = "llcc";
 	edev_ctl->panic_on_ue = LLCC_ERP_PANIC_ON_UE;
-	edev_ctl->pvt_info = llcc_driv_data;
 
 	rc = edac_device_add_device(edev_ctl);
 	if (rc)


