Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E017755C608
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbiF0Ls6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbiF0Lpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:45:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D955DFA6;
        Mon, 27 Jun 2022 04:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7036D60C16;
        Mon, 27 Jun 2022 11:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619A8C3411D;
        Mon, 27 Jun 2022 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329946;
        bh=PP2PMJVLn3A28UGkaTPM3Bqpt/0AYPq+7znq3zswsO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVeZ6waVrOs3wT5I3GbXt/ovU2bOOvSYSKy7uZ98jHrM27aSn9fjMAEURH7DwIqI6
         XKtIyadqwrL8NKhp/nWRGDS9F6mLvJP8O25KBPmqSMCVHMn3JzlLQJCslFmaoVtT1l
         G1y9m1CbXGOQi92dFYK7wUzp6RDhim+mylMpBPVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 005/181] ALSA: hda: Fix discovery of i915 graphics PCI device
Date:   Mon, 27 Jun 2022 13:19:38 +0200
Message-Id: <20220627111944.715840860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 36a38c53b4ee51b90566f8f44a613601eb31a10e upstream.

It's been reported that the recent fix for skipping the
component-binding with D-GPU caused a regression on some systems; it
resulted in the completely missing component binding with i915 GPU.

The problem was the use of pci_get_class() function.  It matches with
the full PCI class bits, while we want to match only partially the PCI
base class bits.  So, when a system has an i915 graphics device with
the PCI class 0380, it won't hit because we're looking for only the
PCI class 0300.

This patch fixes i915_gfx_present() to look up each PCI device and
match with PCI base class explicitly instead of pci_get_class().

Fixes: c9db8a30d9f0 ("ALSA: hda/i915 - skip acomp init if no matching display")
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Tested-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1200611
Link: https://lore.kernel.org/r/87bkunztec.wl-tiwai@suse.de
Link: https://lore.kernel.org/r/20220621120044.11573-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/hdac_i915.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/sound/hda/hdac_i915.c b/sound/hda/hdac_i915.c
index 3f35972e1cf7..161a9711cd63 100644
--- a/sound/hda/hdac_i915.c
+++ b/sound/hda/hdac_i915.c
@@ -119,21 +119,18 @@ static int i915_component_master_match(struct device *dev, int subcomponent,
 /* check whether Intel graphics is present and reachable */
 static int i915_gfx_present(struct pci_dev *hdac_pci)
 {
-	unsigned int class = PCI_BASE_CLASS_DISPLAY << 16;
 	struct pci_dev *display_dev = NULL;
-	bool match = false;
 
-	do {
-		display_dev = pci_get_class(class, display_dev);
-
-		if (display_dev && display_dev->vendor == PCI_VENDOR_ID_INTEL &&
+	for_each_pci_dev(display_dev) {
+		if (display_dev->vendor == PCI_VENDOR_ID_INTEL &&
+		    (display_dev->class >> 16) == PCI_BASE_CLASS_DISPLAY &&
 		    connectivity_check(display_dev, hdac_pci)) {
 			pci_dev_put(display_dev);
-			match = true;
+			return true;
 		}
-	} while (!match && display_dev);
+	}
 
-	return match;
+	return false;
 }
 
 /**
-- 
2.36.1



