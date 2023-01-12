Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D651667542
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbjALOTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjALOT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0164BD62
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E80F9B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34733C433D2;
        Thu, 12 Jan 2023 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532661;
        bh=kNE3Ff2m9fxKW/5EpwglTxVKAmKmMlvjtMJZWhmMJD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVs/AsgsDPbbUxarP2+aSbqMik+TlmMQ/vaQwhIrYWXlEXkIFkGAazjjiQIRvo+MB
         BUTx6jjT/7FwNNSdMa8y7lJNwuQD9UG8kIpWh/4McN4W/PSZ4zAxkxOCzgDlsS4Iwv
         XVYDxj5kvhzwZo8Yz5St+AHXGTWgYpqlQ12d+rUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/783] mmc: via-sdmmc: fix return value check of mmc_add_host()
Date:   Thu, 12 Jan 2023 14:49:10 +0100
Message-Id: <20230112135535.218249391@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e4e46fb61e3bb4628170810d3f2b996b709b90d9 ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

Fix this by checking the return value and goto error path which
will call mmc_free_host().

Fixes: f0bf7f61b840 ("mmc: Add new via-sdmmc host controller driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221108130949.1067699-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/via-sdmmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index f07c71db3caf..f6b525fb5c0e 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1154,7 +1154,9 @@ static int via_sd_probe(struct pci_dev *pcidev,
 	    pcidev->subsystem_device == 0x3891)
 		sdhost->quirks = VIA_CRDR_QUIRK_300MS_PWRDELAY;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto unmap;
 
 	return 0;
 
-- 
2.35.1



