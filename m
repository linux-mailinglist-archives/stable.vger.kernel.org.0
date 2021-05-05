Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC703744A7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhEEQ66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234412AbhEEQ4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D04B6199B;
        Wed,  5 May 2021 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232747;
        bh=0FEt7kcMQl4vrY4tnLxDRxMhoglO1LkLLEobny08FD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGWqb3wTCiay4qlpdr/MMoqn6xiFPDuo5VLll5IIGdRQ6vw50l48zmoN8VCKqStUW
         G0HTJlzTrtoJgKqqfCZK8L+Qt844706PfX3bgansqnx9IY1RAPHn6jWTf85aII+Fe+
         W4MyMdq3enaKH6uWdXoGcdG1RVUoz72C/ykILD636sbnJ038Md6bPUslG1+AZYY+Cb
         99lW1fqijSwjX7Tbi/0gvBlhUjZd/rU387VQzDGMJuKP8Khpdg5Ca162ZYq3Bh7jgs
         Aa9DSB89wP7QLWu29voe1np9OgE8wHlEp31IxWuyKBJGdjynrAH66tjgEHnnSA+hUU
         gCvD9jSrnruvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 07/46] ALSA: hdsp: don't disable if not enabled
Date:   Wed,  5 May 2021 12:38:17 -0400
Message-Id: <20210505163856.3463279-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index 5cbdc9be9c7e..c7b3e76ea2d2 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5326,7 +5326,8 @@ static int snd_hdsp_free(struct hdsp *hdsp)
 	if (hdsp->port)
 		pci_release_regions(hdsp->pci);
 
-	pci_disable_device(hdsp->pci);
+	if (pci_is_enabled(hdsp->pci))
+		pci_disable_device(hdsp->pci);
 	return 0;
 }
 
-- 
2.30.2

