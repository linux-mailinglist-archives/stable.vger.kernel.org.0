Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D43F6452
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhHXRDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238805AbhHXRBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F2B615A7;
        Tue, 24 Aug 2021 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824275;
        bh=QiFxqNIpjxgQVfHg9iJxZBLdgVazw/dG0F84HS+bcGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKywJCCGBwljZ59dT298jYEK/CACXcFnGxR8mgsmLaCB1A0ITdql0y2SX8L3cMHDn
         xjusz+IbWIvqrVg3TNzRn1VNMiBPpdUIfEulCe0Zrk45E5vR853hxJEN5alwwFFAI7
         9tQ3nvR5pQyYv6LC76BM7aUWr9MZ3EEkz6cX1xvGHocDd8f5SN9mOvlq1Yae2GQpfv
         GbhQ2oWmTVTf/+agFKeLEx9No2BdWp5N1nNM+xAd4ty7VGvgxIu0EpiJP51zT4t+XU
         1d+5zmdNMWYOyYtAQVXbCGojzQHm0LdledYos5sGZApTeG/xa3r14OgE5v9gLmk7YJ
         8SpoLPOjiBSfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 110/127] ALSA: hda/via: Apply runtime PM workaround for ASUS B23E
Date:   Tue, 24 Aug 2021 12:55:50 -0400
Message-Id: <20210824165607.709387-111-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4bf61ad5f0204b67ba570da6e5c052c2095e29df ]

ASUS B23E requires the same workaround like other machines with
VT1802, otherwise it looses the codec power on a few nodes and the
sound kept silence.

Fixes: a0645daf1610 ("ALSA: HDA: Early Forbid of runtime PM")
Link: https://lore.kernel.org/r/ac2232f142efcd67fe6ac38897f704f7176bd200.camel@gmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210817052432.14751-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_via.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index a5c1a2c4eae4..773a136161f1 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1041,6 +1041,7 @@ static const struct hda_fixup via_fixups[] = {
 };
 
 static const struct snd_pci_quirk vt2002p_fixups[] = {
+	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
-- 
2.30.2

