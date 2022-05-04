Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4B51A928
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355786AbiEDRMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356876AbiEDRJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2406C44747;
        Wed,  4 May 2022 09:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6ADBB827A1;
        Wed,  4 May 2022 16:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E75AC385A4;
        Wed,  4 May 2022 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683372;
        bh=z8W341Ff4rmUGeYvixTSXtHcgH7Y0qDlJv67ciz3vJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9TTw3vbD59G6y9KEer/ON4X3aaNkHwCPf9wgPOqFt/tRhv2G5fE6g+aCpiWZcGWe
         Ri9AEtO1+frDCfiSBvdIdGGumBliIGWRgzUdA93vyR8rgCMMXtkD34JLMM2oEHufMn
         MlaCnRhDqQfJ4GwBAFOBbbek1E+IuLF1dys7V5Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhaumik Vasav Bhatt <quic_bbhatt@quicinc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.17 043/225] bus: mhi: host: pci_generic: Flush recovery worker during freeze
Date:   Wed,  4 May 2022 18:44:41 +0200
Message-Id: <20220504153113.980245250@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit c38f83bae4037023827c85e045841d0421f85034 upstream.

It is possible that the recovery work might be running while the freeze
gets executed (during hibernation etc.,). Currently, we don't powerdown
the stack if it is not up but if the recovery work completes after freeze,
then the device will be up afterwards. This will not be a sane situation.

So let's flush the recovery worker before trying to powerdown the device.

Cc: stable@vger.kernel.org
Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
Reported-by: Bhaumik Vasav Bhatt <quic_bbhatt@quicinc.com>
Reviewed-by: Bhaumik Vasav Bhatt <quic_bbhatt@quicinc.com>
Link: https://lore.kernel.org/r/20220408150039.17297-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -1060,6 +1060,7 @@ static int __maybe_unused mhi_pci_freeze
 	 * the intermediate restore kernel reinitializes MHI device with new
 	 * context.
 	 */
+	flush_work(&mhi_pdev->recovery_work);
 	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
 		mhi_power_down(mhi_cntrl, true);
 		mhi_unprepare_after_power_down(mhi_cntrl);


