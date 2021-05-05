Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6B037420E
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhEEQnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235386AbhEEQlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9DCF6162B;
        Wed,  5 May 2021 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232480;
        bh=1fgGe6EVea6dgSAsAZvzBziRCktDtmZTRV18UlD/8CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1Ae8uag7JfppO5nR/fuZFsdJjv5UrNbAL7Zr7dVkdontUwO5gKH4GuY6AQtMBbQn
         Scab2N3Ca10PYvVdgVeKIdUn+KUUzIsp5GovhMicBunUd7aUFDp2k+ABJcfsjZdgXV
         Yr3hKEf1SRWAE8hgK7Kx6Q51f8FzQ+be/4ikKLkY8bP2+zDKRJLWsCNFuw4NSEBDyV
         oGvKpu1D3Chqlk+P2/KmY//PvEFvFHDZt5/1Q9b1ZQzjKgY/cTGIowZNQX+mxmJCHV
         ylXz/cOWdQX8tYr6no70DZeBRmc1DH/BrEt68l1SJW4AdTAJyhFdk3fQHHs4xtNcai
         vt2EjWxzORRgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 019/104] ALSA: hdsp: don't disable if not enabled
Date:   Wed,  5 May 2021 12:32:48 -0400
Message-Id: <20210505163413.3461611-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 507cdb9adba006a7798c358456426e1aea3d9c4f ]

hdsp wants to disable a not enabled pci device, which makes kernel
throw a warning. Make sure the device is enabled before calling disable.

[    1.758292] snd_hdsp 0000:00:03.0: disabling already-disabled device
[    1.758327] WARNING: CPU: 0 PID: 180 at drivers/pci/pci.c:2146 pci_disable_device+0x91/0xb0
[    1.766985] Call Trace:
[    1.767121]  snd_hdsp_card_free+0x94/0xf0 [snd_hdsp]
[    1.767388]  release_card_device+0x4b/0x80 [snd]
[    1.767639]  device_release+0x3b/0xa0
[    1.767838]  kobject_put+0x94/0x1b0
[    1.768027]  put_device+0x13/0x20
[    1.768207]  snd_card_free+0x61/0x90 [snd]
[    1.768430]  snd_hdsp_probe+0x524/0x5e0 [snd_hdsp]

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210321153840.378226-2-ztong0001@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/rme9652/hdsp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index cea53a878c36..4aee30db034d 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5321,7 +5321,8 @@ static int snd_hdsp_free(struct hdsp *hdsp)
 	if (hdsp->port)
 		pci_release_regions(hdsp->pci);
 
-	pci_disable_device(hdsp->pci);
+	if (pci_is_enabled(hdsp->pci))
+		pci_disable_device(hdsp->pci);
 	return 0;
 }
 
-- 
2.30.2

