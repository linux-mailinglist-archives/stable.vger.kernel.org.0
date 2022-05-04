Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC8E51A86D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiEDRK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356760AbiEDRJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E817E6354;
        Wed,  4 May 2022 09:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C352B82792;
        Wed,  4 May 2022 16:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACC3C385A4;
        Wed,  4 May 2022 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683330;
        bh=n9Q/W/occ0bb07vn7HK5qwDHGDLUQo+K6rMhV1GBuo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0REyl/uWvNRLngLs59+DHV71bKP3fAiycDWJauSOh5Sx9VTUSoFdwakcuimuy3Eu
         Qgkl9iRTVKOwQyS76/8GGmIU1dBbNxXtSg6BF5fxzA1Uda/mNNWe2ULV5kXNvNXbOZ
         3KbrV2b2wSOsd/EUp5UpzZ9EkHGT9ED04PG927BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 5.17 009/225] usb: xhci: tegra:Fix PM usage reference leak of tegra_xusb_unpowergate_partitions
Date:   Wed,  4 May 2022 18:44:07 +0200
Message-Id: <20220504153111.114797832@linuxfoundation.org>
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

From: zhangqilong <zhangqilong3@huawei.com>

commit 8771039482d965bdc8cefd972bcabac2b76944a8 upstream.

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: 41a7426d25fa ("usb: xhci: tegra: Unlink power domain devices")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220319023822.145641-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1034,13 +1034,13 @@ static int tegra_xusb_unpowergate_partit
 	int rc;
 
 	if (tegra->use_genpd) {
-		rc = pm_runtime_get_sync(tegra->genpd_dev_ss);
+		rc = pm_runtime_resume_and_get(tegra->genpd_dev_ss);
 		if (rc < 0) {
 			dev_err(dev, "failed to enable XUSB SS partition\n");
 			return rc;
 		}
 
-		rc = pm_runtime_get_sync(tegra->genpd_dev_host);
+		rc = pm_runtime_resume_and_get(tegra->genpd_dev_host);
 		if (rc < 0) {
 			dev_err(dev, "failed to enable XUSB Host partition\n");
 			pm_runtime_put_sync(tegra->genpd_dev_ss);


