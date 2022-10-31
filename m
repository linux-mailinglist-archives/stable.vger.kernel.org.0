Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1C613070
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJaGjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiJaGjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:39:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BA25FDA
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7D64CE118C
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC54C4347C;
        Mon, 31 Oct 2022 06:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198337;
        bh=twEN9fosR24yzQyvVYuBogcDb9Sd5TPoH5tVKP8nCM4=;
        h=Subject:To:Cc:From:Date:From;
        b=NmeLLg0VRYs+aOJgZQxBJ9ZxpkSnExBj12PEEOu1fQ2gmBvskYif/eF/L5RiLIlQe
         +Kn3XQVeI3WlxETo50WbNplxnHhV66843d4MU5/YIU9s76UhHcntExvNwOvxOMsv+S
         pYX/iNzNNf0rQPorrznP3tB6VHN/Dd9M7QQgoQjI=
Subject: FAILED: patch "[PATCH] mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO" failed to apply to 5.4-stable tree
To:     briannorris@chromium.org, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:39:50 +0100
Message-ID: <166719839022420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8d280b1df87e ("mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO")
f545702b74f9 ("mmc: sdhci_am654: Add Support for Command Queuing Engine to J721E")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8d280b1df87e0b3d1355aeac7e62b62214b93f1c Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Mon, 24 Oct 2022 11:02:59 -0700
Subject: [PATCH] mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO

REGMAP_MMIO is not user-configurable, so we can only satisfy this
dependency by enabling some other Kconfig symbol that properly 'select's
it. Use select like everybody else.

Noticed when trying to enable this driver for compile testing.

Fixes: 59592cc1f593 ("mmc: sdhci_am654: Add dependency on MMC_SDHCI_AM654")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221024180300.2292208-1-briannorris@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index f324daadaf70..fb1062a6394c 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1075,9 +1075,10 @@ config MMC_SDHCI_OMAP
 
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

