Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A123C3093
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhGJCfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235630AbhGJCe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23777613F4;
        Sat, 10 Jul 2021 02:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884315;
        bh=XR3dWfvD9cMKxo2cyYHMTS9Hz+WqHyups7DSJhlqi0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ms1fBD+VqcKNM1xYpUTDBqaVvIhcXFr4GTFPQd8Z5r6rP/OL7kl984339rCnbRf4i
         EAzq0+cgLt+xAJbyiQoPSGOfFS6JHEK8AewRwPRlIrvorvVswA8Ki1naI9dytaZsKC
         S+boP/iKao2Sd/gCKQbECXcVArqircWcTmhhtr6Cu8wPTrpznVXGzQaPU3hKT1tSwr
         qC4JZuk5+8IAFgcvIeUffNQR6fToo0odelURE5FU+/TtZVpt8gsJxD7UlLNIIzMhfi
         /HtuKuJZ/IwSm36qGdp6oPvDFaVBIRyVhtHYEf76qkbMQ3G7InEAOZBnVC9GGN8hgy
         ZYsxtXBAJi4fQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiajun Cao <jjcao20@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 57/63] ALSA: hda: Add IRQ check for platform_get_irq()
Date:   Fri,  9 Jul 2021 22:27:03 -0400
Message-Id: <20210710022709.3170675-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiajun Cao <jjcao20@fudan.edu.cn>

[ Upstream commit 8c13212443230d03ff25014514ec0d53498c0912 ]

The function hda_tegra_first_init() neglects to check the return
value after executing platform_get_irq().

hda_tegra_first_init() should check the return value (if negative
error number) for errors so as to not pass a negative value to
the devm_request_irq().

Fix it by adding a check for the return value irq_id.

Signed-off-by: Jiajun Cao <jjcao20@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20210622131947.94346-1-jjcao20@fudan.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index e378cb33c69d..2971b34c87c1 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -292,6 +292,9 @@ static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
 	const char *sname, *drv_name = "tegra-hda";
 	struct device_node *np = pdev->dev.of_node;
 
+	if (irq_id < 0)
+		return irq_id;
+
 	err = hda_tegra_init_chip(chip, pdev);
 	if (err)
 		return err;
-- 
2.30.2

