Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88449BA857
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439102AbfIVTCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439092AbfIVTCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:02:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8638F2184D;
        Sun, 22 Sep 2019 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178931;
        bh=agcK21fovO8R8OBGihJ+5fxidtN3+4UA9+YgcXgx4gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obCfffMojCyCvi8RWh6hRzRZd50k4xIvv1Io7Jd9wTavz2m9UafdeMVMoD/kmF4Bn
         e/cf7qfwOIomBKAwyuoPv8klGsuYrJbyYr17XTJIHnSiPBRE4OedMFZTQuo85RusGB
         tgnKjlYxJJ6gzabCCoPEfgKtX89nV3L1VOXWwLj4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 43/44] ALSA: hda/realtek - Blacklist PC beep for Lenovo ThinkCentre M73/93
Date:   Sun, 22 Sep 2019 15:01:01 -0400
Message-Id: <20190922190103.4906-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 051c78af14fcd74a22b5af45548ad9d588247cc7 ]

Lenovo ThinkCentre M73 and M93 don't seem to have a proper beep
although the driver tries to probe and set up blindly.
Blacklist these machines for suppressing the beep creation.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204635
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d5ca16048ce0d..55bae9e6de27d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -977,6 +977,9 @@ static const struct snd_pci_quirk beep_white_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x834a, "EeePC", 1),
 	SND_PCI_QUIRK(0x1458, 0xa002, "GA-MA790X", 1),
 	SND_PCI_QUIRK(0x8086, 0xd613, "Intel", 1),
+	/* blacklist -- no beep available */
+	SND_PCI_QUIRK(0x17aa, 0x309e, "Lenovo ThinkCentre M73", 0),
+	SND_PCI_QUIRK(0x17aa, 0x30a3, "Lenovo ThinkCentre M93", 0),
 	{}
 };
 
-- 
2.20.1

