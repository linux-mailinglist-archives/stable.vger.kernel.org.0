Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BFB3CE0F5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347218AbhGSPTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346985AbhGSPPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E806610D0;
        Mon, 19 Jul 2021 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710163;
        bh=7bQyvyrIOLxHq3iMmmb+Sew8OPmdn8AHueo5G5Hq3gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQ4avyHK/OLopxsRkpCh/kPLqmiU8L0yiJlE2yS0kxWwpgFMckrD+lwBoVFUi43aC
         eKagYuqyTZ6gNtr51z0ZHup20nDxzTJIriI2Iupw6jYcwAgBUVEW0+/ZGVBHfaQEy4
         rpwpZoL0yQhAEs0qfTfTpWIZlyBieSz8L9LsZV/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiajun Cao <jjcao20@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/243] ALSA: hda: Add IRQ check for platform_get_irq()
Date:   Mon, 19 Jul 2021 16:52:10 +0200
Message-Id: <20210719144944.148858185@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 361cf2041911..07787698b973 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -302,6 +302,9 @@ static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
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



