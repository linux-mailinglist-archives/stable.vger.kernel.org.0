Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1473C31B2
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhGJCnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235267AbhGJCmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C614613E4;
        Sat, 10 Jul 2021 02:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884747;
        bh=L97dLeP6erxCCovARaRHBZiyyAeRSD+wLyweSRUnot8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaYDYPVci2/iArRrQkbzwh2FcGqPVdH5NdVtC0C4RZ0wEd7JqeclcjoWO8sYyQeXk
         qw0nWbmAsqwtBWraxX4vpCM85xnH7E6h8O4eTKWsHTyteJzKfJU2VEJjy11OZEHdCw
         A5m7dQcSWwdHA7uUqZJGfY4J0Gkk5ZJcUQIraY9qvVHYwjmnuxjEebZBcYbi8omKIL
         7JwpahoZrphuElV1rJrYXEZ2LZxB2z9Qd2BCq/D3BK9g6EaBJDD9yhkPHZATMZwrI6
         g6FpFlHcnk2LFh/JINtodS/U8r29EkJwXn/e/eH8fJRwVKmziICZeAhTMBKHMPT2QK
         IvZQzh6yqY3Ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiajun Cao <jjcao20@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 23/26] ALSA: hda: Add IRQ check for platform_get_irq()
Date:   Fri,  9 Jul 2021 22:36:01 -0400
Message-Id: <20210710023604.3172486-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
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
index e85fb04ec7be..b567c4bdae00 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -363,6 +363,9 @@ static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
 	unsigned short gcap;
 	int irq_id = platform_get_irq(pdev, 0);
 
+	if (irq_id < 0)
+		return irq_id;
+
 	err = hda_tegra_init_chip(chip, pdev);
 	if (err)
 		return err;
-- 
2.30.2

