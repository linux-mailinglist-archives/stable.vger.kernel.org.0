Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845426C1744
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjCTPM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjCTPLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:11:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E5D31BFA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9AA03CE12DC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C344C433EF;
        Mon, 20 Mar 2023 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324505;
        bh=ZQN08Rvj9vkrfXEuFNFt+YOWfpT0AYb6Ef2EKp6lOWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAOzy9DL4ignE4/I684z6lsmOkFOgEI12BLwe/2meRXZ+oDLd2jwQGQIzExn4Hd69
         kYZ27PJQevbIfCt9BrAQ6yVM6bTeJicUJFs/3Dq+Ik3W09XKzy12GAYQYfU5Xj7n4L
         fLIxFsP/6HYmof1vQCtL+Wi0/kea9WpZ/NzT1WcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/99] ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()
Date:   Mon, 20 Mar 2023 15:53:46 +0100
Message-Id: <20230320145443.704928264@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
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
index 494bfd2135a9e..de1fe604905f3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -365,14 +365,15 @@ enum {
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
 
-- 
2.39.2



