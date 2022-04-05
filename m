Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BCA4F25F1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiDEHw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiDEHu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C67D9549E;
        Tue,  5 Apr 2022 00:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13E19616C6;
        Tue,  5 Apr 2022 07:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB58C340EE;
        Tue,  5 Apr 2022 07:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144833;
        bh=fA6jlSOTDUzNe8YCEepk5YnDTbZKLllnbhM2A2nSFIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1KfgMuxL9Y6YI/Ums/M16753BKXNofhQVD6AHpKT97NfGO6FxY+kNGN32/KVJkmG
         3g5VZmf2LXRxnHP3l/89dlv2lEH1OB4z/YOXIo648LMSzJ345ozhlAeX0JrF94WtUn
         pzMGWxU1uj48VdbX8ok4a81tCmsgmN5rEXKdmzZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hector Martin <marcan@marcan.st>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.17 0188/1126] brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
Date:   Tue,  5 Apr 2022 09:15:35 +0200
Message-Id: <20220405070413.125522885@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

commit 5e90f0f3ead014867dade7a22f93958119f5efab upstream.

This avoids leaking memory if brcmf_chip_get_raminfo fails. Note that
the CLM blob is released in the device remove path.

Fixes: 82f93cf46d60 ("brcmfmac: get chip's default RAM info during PCIe setup")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220131160713.245637-2-marcan@marcan.st
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1777,6 +1777,8 @@ static void brcmf_pcie_setup(struct devi
 	ret = brcmf_chip_get_raminfo(devinfo->ci);
 	if (ret) {
 		brcmf_err(bus, "Failed to get RAM info\n");
+		release_firmware(fw);
+		brcmf_fw_nvram_free(nvram);
 		goto fail;
 	}
 


