Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581B251AA25
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356660AbiEDRVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357562AbiEDRPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C065520A
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 720BCB827A6
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E4BC385B1;
        Wed,  4 May 2022 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683497;
        bh=gsEZEd7giI+LOqW8G4A/YdRs0EkIF3FQhEY2WEZh+KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jenRXMichO5huic1PJfD6w0K9Wgwu3QWyDCXCHbjkZa/VEUeesWoeXcf+076RMBI6
         gKGPkfQl0tQpyD54BfsK8UTatQQuLh0cGaj2RnRW2peCEqYu+rVe6mlI5gyKWp6Ca9
         65q20wK5HEF+oW3AG2+4TBzm+khblREbQaRlqsPnt5lcnl6IOfYHtmcju90oKGjOCg
         2SxPVhcQNIQvJD50lyop9Kci0+47BYt3YKhuY4LrkcEg4LYFdXBcCXn9cy4JGiAFef
         i8j7gTpZypwIcTPdHAe0Iovgk+BWJBY9ns6dRNUmD6V6eDVQYKHTjOKSS5H+YZVmAS
         R+T87143pPKaw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 11/30] PCI: aardvark: Disable common PHY when unbinding driver
Date:   Wed,  4 May 2022 18:57:36 +0200
Message-Id: <20220504165755.30002-12-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
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

From: Pali Rohár <pali@kernel.org>

commit fdbbe242c15a8f2cd0e3ad8a56cd0a447b771d0d upstream.

Disable the PCIe PHY when unbinding driver. This should save some power.

Link: https://lore.kernel.org/r/20211130172913.9727-12-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 3f6919564434..ae0219ae730a 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1734,6 +1734,9 @@ static int advk_pcie_remove(struct platform_device *pdev)
 	for (i = 0; i < OB_WIN_COUNT; i++)
 		advk_pcie_disable_ob_win(pcie, i);
 
+	/* Disable phy */
+	advk_pcie_disable_phy(pcie);
+
 	return 0;
 }
 
-- 
2.35.1

