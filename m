Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6D2FC6C0
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbhATB22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbhATB2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D069A23330;
        Wed, 20 Jan 2021 01:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105988;
        bh=wYXBU36vIOmvDdKuwLMo2YmG9nlb8T9LIa/JdrEhOfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENhBnytOJQz8q4c/t4fyNNyYZAtCI96Cv2beV+Lwyfk+m6vSiocVTglemNAMUWQQ6
         J1eOF9pZ3dOadO+Yj/+RPUFGy/nU7zO6veyWNyCAuIiACQhKwTIZ27UqK+W09fhDtb
         dOOS/lzBbvvj3/dy5uxd8K6COXOupr3CgbCW2E8O1XWQwjzQVmcxZldQ5csyIaPM54
         Bmd9TANPJP2RBJphEQ6w514BgUKfuhD360RpffgFw4PedddrBvnp50FDYHlm9sClPG
         7zKr9LY1eu2YaeZY9F9d4y3QLeEMEriyIqEik7854QuDQ1F2zF0o0AWK9rn0l9MAww
         AoLsI3tc3eWJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Ion Agorria <ion@agorria.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/45] ALSA: hda/tegra: fix tegra-hda on tegra30 soc
Date:   Tue, 19 Jan 2021 20:25:37 -0500
Message-Id: <20210120012602.769683-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit 615d435400435876ac68c1de37e9526a9164eaec ]

Currently hda on tegra30 fails to open a stream with an input/output error.

For example:
speaker-test -Dhw:0,3 -c 2

speaker-test 1.2.2

Playback device is hw:0,3
Stream parameters are 48000Hz, S16_LE, 2 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 64 to 16384
Period size range from 32 to 8192
Using max buffer size 16384
Periods = 4
was set period_size = 4096
was set buffer_size = 16384
 0 - Front Left
Write error: -5,Input/output error
xrun_recovery failed: -5,Input/output error
Transfer failed: Input/output error

The tegra-hda device was introduced in tegra30 but only utilized in
tegra124 until recent chips. Tegra210/186 work only due to a hardware
change. For this reason it is unknown when this issue first manifested.
Discussions with the hardware team show this applies to all current tegra
chips. It has been resolved in the tegra234, which does not have hda
support at this time.

The explanation from the hardware team is this:
Below is the striping formula referenced from HD audio spec.
   { ((num_channels * bits_per_sample) / number of SDOs) >= 8 }

The current issue is seen because Tegra HW has a problem with boundary
condition (= 8) for striping. The reason why it is not seen on
Tegra210/Tegra186 is because it uses max 2SDO lines. Max SDO lines is
read from GCAP register.

For the given stream (channels = 2, bps = 16);
ratio = (channels * bps) / NSDO = 32 / NSDO;

On Tegra30,      ratio = 32/4 = 8  (FAIL)
On Tegra210/186, ratio = 32/2 = 16 (PASS)
On Tegra194,     ratio = 32/4 = 8  (FAIL) ==> Earlier workaround was
applied for it

If Tegra210/186 is forced to use 4SDO, it fails there as well. So the
behavior is consistent across all these chips.

Applying the fix in [1] universally resolves this issue on tegra30-hda.
Tested on the Ouya game console and the tf201 tablet.

[1] commit 60019d8c650d ("ALSA: hda/tegra: workaround playback failure on
Tegra194")

Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Ion Agorria <ion@agorria.com>
Reviewed-by: Sameer Pujar <spujar@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Link: https://lore.kernel.org/r/20210108135913.2421585-3-pgwipeout@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index 70164d1428d40..361cf2041911a 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -388,7 +388,7 @@ static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
 	 * in powers of 2, next available ratio is 16 which can be
 	 * used as a limiting factor here.
 	 */
-	if (of_device_is_compatible(np, "nvidia,tegra194-hda"))
+	if (of_device_is_compatible(np, "nvidia,tegra30-hda"))
 		chip->bus.core.sdo_limit = 16;
 
 	/* codec detection */
-- 
2.27.0

