Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2D238A482
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbhETKGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235004AbhETKD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E64A61921;
        Thu, 20 May 2021 09:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503628;
        bh=mQVfTlrryjunFbZWL96/mySlJ165PR4ewvd0Lcod80U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONzZKkNhJHWzAsfQZ9E/JO3AZlFaaXH6l77Fb8oC4vAkUAYygOF12bknQBvUA+Kyv
         xF2uSCLyyJT6KnUoMKMuIzK9Xx2ldaJuTbZeVB3y11ikpcyfjAJXYE+4oPXUuJuG3F
         5hUyNUO+/lMgSC89tg3AlohycTH1TVrQzJ86S4EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Tong Zhang <ztong0001@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 308/425] ALSA: hdspm: dont disable if not enabled
Date:   Thu, 20 May 2021 11:21:17 +0200
Message-Id: <20210520092141.560542022@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 790f5719b85e12e10c41753b864e74249585ed08 ]

hdspm wants to disable a not enabled pci device, which makes kernel
throw a warning. Make sure the device is enabled before calling disable.

[    1.786391] snd_hdspm 0000:00:03.0: disabling already-disabled device
[    1.786400] WARNING: CPU: 0 PID: 182 at drivers/pci/pci.c:2146 pci_disable_device+0x91/0xb0
[    1.795181] Call Trace:
[    1.795320]  snd_hdspm_card_free+0x58/0xa0 [snd_hdspm]
[    1.795595]  release_card_device+0x4b/0x80 [snd]
[    1.795860]  device_release+0x3b/0xa0
[    1.796072]  kobject_put+0x94/0x1b0
[    1.796260]  put_device+0x13/0x20
[    1.796438]  snd_card_free+0x61/0x90 [snd]
[    1.796659]  snd_hdspm_probe+0x97b/0x1440 [snd_hdspm]

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210321153840.378226-3-ztong0001@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/rme9652/hdspm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 11b5b5e0e058..5dfddade1bae 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6913,7 +6913,8 @@ static int snd_hdspm_free(struct hdspm * hdspm)
 	if (hdspm->port)
 		pci_release_regions(hdspm->pci);
 
-	pci_disable_device(hdspm->pci);
+	if (pci_is_enabled(hdspm->pci))
+		pci_disable_device(hdspm->pci);
 	return 0;
 }
 
-- 
2.30.2



