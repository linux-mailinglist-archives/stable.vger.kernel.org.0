Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFB299AF4
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfHVRRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390313AbfHVRI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:26 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C5923428;
        Thu, 22 Aug 2019 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493705;
        bh=JwKonAnhnJDtmOh5rSqNqF2FnVom8Tv1hj/NUGm+wPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ega1B5HGZtgkqBhcmFw9MgvXKAU3cU8kC6F6ey5FItD/HL7CS52Ctf0LBgnPDjLZV
         qHe5I2QQAe0eT1C6JVeg1mbKtgV5GCL9JZj+oA1beJwe5drGxC136wVsHrFMXoTNbB
         AUolDAbX+ojWjpbvGNyXK2tiIkse7zFRGtQ0xNFg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 020/135] ALSA: hda - Apply workaround for another AMD chip 1022:1487
Date:   Thu, 22 Aug 2019 13:06:16 -0400
Message-Id: <20190822170811.13303-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit de768ce45466f3009809719eb7b1f6f5277d9373 upstream.

MSI MPG X570 board is with another AMD HD-audio controller (PCI ID
1022:1487) and it requires the same workaround applied for X370, etc
(PCI ID 1022:1457).

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=195303
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index fb8f452a1c78a..5732c31c41670 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2505,6 +2505,9 @@ static const struct pci_device_id azx_ids[] = {
 	/* AMD, X370 & co */
 	{ PCI_DEVICE(0x1022, 0x1457),
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_AMD_SB },
+	/* AMD, X570 & co */
+	{ PCI_DEVICE(0x1022, 0x1487),
+	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_AMD_SB },
 	/* AMD Stoney */
 	{ PCI_DEVICE(0x1022, 0x157a),
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_SB |
-- 
2.20.1

