Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428716C1676
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjCTPGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjCTPFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:05:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B91B2F048
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2622461590
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395AAC433EF;
        Mon, 20 Mar 2023 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324497;
        bh=taXw3zqC5wrugL59ed80lWuJKQca38L9EcAOuo4REzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9pt37ZrMlTgWPJuKNsi/5bsEvFNMI2vOTMptLPSdn8B+gGyGBYHSomfhEaDzgIie
         WreHx/2uqDSu7NfnSRpO5cjswMek6Jst6OHFWQLyEa5jp3YW0YmmJnUoNgumzIeqCG
         nAZUtuHgzyv5NjuVE28fk5Dwu0aSRqO/+mSOKUQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/60] ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()
Date:   Mon, 20 Mar 2023 15:54:22 +0100
Message-Id: <20230320145431.434095475@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit ff447886e675979d66b2bc01810035d3baea1b3a ]

CONTROLLER_IN_GPU() is clearly intended to match only Intel devices, but
previously it checked only the PCI Device ID, not the Vendor ID, so it
could match devices from other vendors that happened to use the same Device
ID.

Update CONTROLLER_IN_GPU() so it matches only Intel devices.

Fixes: 535115b5ff51 ("ALSA: hda - Abort the probe without i915 binding for HSW/B")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20230307214054.886721-1-helgaas@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 018005b29931f..9b7a345233cf6 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -363,14 +363,15 @@ enum {
 #define needs_eld_notify_link(chip)	false
 #endif
 
-#define CONTROLLER_IN_GPU(pci) (((pci)->device == 0x0a0c) || \
+#define CONTROLLER_IN_GPU(pci) (((pci)->vendor == 0x8086) &&         \
+				       (((pci)->device == 0x0a0c) || \
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
 					((pci)->device == 0x490d) || \
 					((pci)->device == 0x4f90) || \
 					((pci)->device == 0x4f91) || \
-					((pci)->device == 0x4f92))
+					((pci)->device == 0x4f92)))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 #define IS_CFL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0xa348)
-- 
2.39.2



