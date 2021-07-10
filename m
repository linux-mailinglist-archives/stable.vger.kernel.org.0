Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553193C31E3
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhGJCpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235408AbhGJCns (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:43:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868D561409;
        Sat, 10 Jul 2021 02:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884784;
        bh=+GxOXwBIVChAEIPaJlTqVRD9YIlZFBH0s/v8OF5M8is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBRc8JRgMf5yDi2YaVcLlvQFWEgdJ7CTSVImLjzdFS9EiG2Z4eWQ+hQTXGc3BWJf9
         k7JJmxZUWvTC38wXxRODnHJm2/Nw53dpYtQ1os6sn26gG5DSacIPGk4mlN1PR825iU
         R1PI5ACcj7hd4pMcHBp/gKP+xLWpPYg9ojiWfvJz85ZwKdb0Tma8zZWQRU9qCY9ZBD
         Jyv5jMjhzal4HujEItagPzKudhUHVPNjjSVrBFE+5i685xM9zR+IMQAKIdSTY0H/4b
         ZYXP6ISLj9dEMpIHdBMtifCbht8ZT+NtNHytwCO08jZseIHzutyoOO4F9T8iftkrLQ
         aFGvEYaKZqnqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiajun Cao <jjcao20@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 21/23] ALSA: hda: Add IRQ check for platform_get_irq()
Date:   Fri,  9 Jul 2021 22:39:10 -0400
Message-Id: <20210710023912.3172972-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023912.3172972-1-sashal@kernel.org>
References: <20210710023912.3172972-1-sashal@kernel.org>
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
index 039fbbb1e53c..89359a962e47 100644
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

