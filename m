Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89F366CCB1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbjAPR2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjAPR20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:28:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D36A38648
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD96F61089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47DAC433EF;
        Mon, 16 Jan 2023 17:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888713;
        bh=blH3d+UkUxe/bSFofWoItyz0MullKSBfY13njVQO3go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLH+Uf4nKVeCXn3qazGOvmMgfQcptbs6tKb7VYyiXg+kK++Kwt1ftABQqKXDmrlcs
         +/CixZ+zR3IR6CWT3X88HhApPcvlv5q1qntQMr3ltfzmmJUZMxU4gXjaYgpiO6B8ZR
         ME/sZb2tru39+y0h3t8qmQZmMkl+w2xAAHYAAzLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 109/338] mmc: via-sdmmc: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:49:42 +0100
Message-Id: <20230116154825.603562401@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index 4e5043657ee2..70905d9beb38 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -1168,7 +1168,9 @@ static int via_sd_probe(struct pci_dev *pcidev,
 	    pcidev->subsystem_device == 0x3891)
 		sdhost->quirks = VIA_CRDR_QUIRK_300MS_PWRDELAY;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto unmap;
 
 	return 0;
 
-- 
2.35.1



