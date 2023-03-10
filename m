Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E42C6B4613
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjCJOjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjCJOjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:39:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56129E679
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5964EB822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E21C4339C;
        Fri, 10 Mar 2023 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459184;
        bh=RVLTcJhYJntpUregILNp9hVDn8VK0ojAgvqQ2pfK1lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaTLDJoQ3fNpYMa/PmD3t8wQiuZbMP35EkGInvn8eztkYATORXfr6IyQV3xR8b2HC
         IWxchrNRLESKAUw6hdbr8uTubv71Z6vSeNjSNsCUqBIlZY1mcSwxiZf1g/W0kiHUzF
         5M/MnePRpmVaV0h3sy393oTuR83/3lK8u8t3AtxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ravi Kishore Koppuravuri <ravi.kishore.koppuravuri@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 5.4 276/357] PCI/PM: Observe reset delay irrespective of bridge_d3
Date:   Fri, 10 Mar 2023 14:39:25 +0100
Message-Id: <20230310133746.926663594@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 8ef0217227b42e2c34a18de316cee3da16c9bf1e upstream.

If a PCI bridge is suspended to D3cold upon entering system sleep,
resuming it entails a Fundamental Reset per PCIe r6.0 sec 5.8.

The delay prescribed after a Fundamental Reset in PCIe r6.0 sec 6.6.1
is sought to be observed by:

  pci_pm_resume_noirq()
    pci_pm_bridge_power_up_actions()
      pci_bridge_wait_for_secondary_bus()

However, pci_bridge_wait_for_secondary_bus() bails out if the bridge_d3
flag is not set.  That flag indicates whether a bridge is allowed to
suspend to D3cold at *runtime*.

Hence *no* delay is observed on resume from system sleep if runtime
D3cold is forbidden.  That doesn't make any sense, so drop the bridge_d3
check from pci_bridge_wait_for_secondary_bus().

The purpose of the bridge_d3 check was probably to avoid delays if a
bridge remained in D0 during suspend.  However the sole caller of
pci_bridge_wait_for_secondary_bus(), pci_pm_bridge_power_up_actions(),
is only invoked if the previous power state was D3cold.  Hence the
additional bridge_d3 check seems superfluous.

Fixes: ad9001f2f411 ("PCI/PM: Add missing link delays required by the PCIe spec")
Link: https://lore.kernel.org/r/eb37fa345285ec8bacabbf06b020b803f77bdd3d.1673769517.git.lukas@wunner.de
Tested-by: Ravi Kishore Koppuravuri <ravi.kishore.koppuravuri@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4743,7 +4743,7 @@ void pci_bridge_wait_for_secondary_bus(s
 	if (pci_dev_is_disconnected(dev))
 		return;
 
-	if (!pci_is_bridge(dev) || !dev->bridge_d3)
+	if (!pci_is_bridge(dev))
 		return;
 
 	down_read(&pci_bus_sem);


