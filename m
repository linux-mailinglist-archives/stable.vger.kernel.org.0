Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B3259448C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346864AbiHOWCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348552AbiHOWBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C751A8277A;
        Mon, 15 Aug 2022 12:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 991E56114B;
        Mon, 15 Aug 2022 19:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98152C433D6;
        Mon, 15 Aug 2022 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592147;
        bh=DjhUQ8cm8P60U+l9dj6IIm427jOlJO/2HHQIDVr5GKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytorR74/mMZZcy6mdoqNP6htQPS3BSPflVs8SJcJ3EolcS3k2ZYD21uQBQUeuO0SS
         AleKEGpldgBINKyII+/1itiygYoThp/4J2uDjRvsETx3QhOO9YF4agZ0zv+iqFAKB4
         807gNvCgbM2jhqgYVRmdWHNDLsp1v93SgQCY8hs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0741/1095] mmc: mxcmmc: Silence a clang warning
Date:   Mon, 15 Aug 2022 20:02:20 +0200
Message-Id: <20220815180500.028237189@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 7dc65e3c0ef4b746a583b7c58f99873fddf5ccfa ]

Change the of_device_get_match_data() cast to (uintptr_t)
to silence the following clang warning:

drivers/mmc/host/mxcmmc.c:1028:18: warning: cast to smaller integer type 'enum mxcmci_type' from 'const void *' [-Wvoid-pointer-to-enum-cast]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 8223e885e74b ("mmc: mxc: Convert the driver to DT-only")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20220526010022.1163483-1-festevam@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxcmmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 40b6878bea6c..b5940083a108 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1025,7 +1025,7 @@ static int mxcmci_probe(struct platform_device *pdev)
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
 	mmc->max_seg_size = mmc->max_req_size;
 
-	host->devtype = (enum mxcmci_type)of_device_get_match_data(&pdev->dev);
+	host->devtype = (uintptr_t)of_device_get_match_data(&pdev->dev);
 
 	/* adjust max_segs after devtype detection */
 	if (!is_mpc512x_mmc(host))
-- 
2.35.1



