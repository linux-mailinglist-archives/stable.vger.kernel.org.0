Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4989A6158EE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiKBDBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiKBDBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:01:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67C123142
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80F58B82064
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689D3C433D6;
        Wed,  2 Nov 2022 03:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358072;
        bh=OsU4JgnYD/HidOS0hIsT0JOBsXD/By05+b85NytdXa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geUUKLDDeXv7YlrzCTTTiRPbtvpfqQ9iaunUZLNUDMLIXHXO2nEUaWLfaSJ0v/M2W
         TpbvabAuXD/htCP1XRNB4iItmo5tOMJ69jIV6lcq9pwRbprl1TsYqb64hXclMWc1M+
         9W5x3dmYyUMa2wK0BGDcgbaX5EEZ43zMsZDApF/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Norris <briannorris@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 036/132] mmc: sdhci_am654: select, not depends REGMAP_MMIO
Date:   Wed,  2 Nov 2022 03:32:22 +0100
Message-Id: <20221102022100.581457173@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 8d280b1df87e0b3d1355aeac7e62b62214b93f1c upstream.

REGMAP_MMIO is not user-configurable, so we can only satisfy this
dependency by enabling some other Kconfig symbol that properly 'select's
it. Use select like everybody else.

Noticed when trying to enable this driver for compile testing.

Fixes: 59592cc1f593 ("mmc: sdhci_am654: Add dependency on MMC_SDHCI_AM654")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221024180300.2292208-1-briannorris@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1069,9 +1069,10 @@ config MMC_SDHCI_OMAP
 
 config MMC_SDHCI_AM654
 	tristate "Support for the SDHCI Controller in TI's AM654 SOCs"
-	depends on MMC_SDHCI_PLTFM && OF && REGMAP_MMIO
+	depends on MMC_SDHCI_PLTFM && OF
 	select MMC_SDHCI_IO_ACCESSORS
 	select MMC_CQHCI
+	select REGMAP_MMIO
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  support present in TI's AM654 SOCs. The controller supports


