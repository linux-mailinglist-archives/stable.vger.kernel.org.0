Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420943CDF9B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343894AbhGSPK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345898AbhGSPJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D024761242;
        Mon, 19 Jul 2021 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709786;
        bh=XR3dWfvD9cMKxo2cyYHMTS9Hz+WqHyups7DSJhlqi0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRnzf5EutkvMwK/gtDwWZtGgLHk61iy3CiNKaCE27Uvvo7utKFZlMzdY5piNp/Mv0
         PqTnduLuBAnzNk611qC6bN+sly1lLoEouHoFh7c7gcNkBqsN1dSLTgDrbpjnuJaSUD
         dZtJreYsHvZoua3o17sI1xtnhYDUcCq6HE4jP/64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiajun Cao <jjcao20@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/149] ALSA: hda: Add IRQ check for platform_get_irq()
Date:   Mon, 19 Jul 2021 16:52:51 +0200
Message-Id: <20210719144916.279771226@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



