Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC2FA540
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfKMBxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:53:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfKMBxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F383222CD;
        Wed, 13 Nov 2019 01:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610022;
        bh=NouXRorkRrtpgDixB7XImri5OC4Rykp1q93l1bDDyYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcg1bHC1Z2DASpuAe678wbG2I95Unqb1w9un7phbNKO6BxJc1VJDvUtmilQLwuDWa
         VrXdwHKfg6tVDkQFCw+w0ww9bZvtEyqxZW28/RW4xNoTZ6d5Cnhc9myoO6V86E3cuF
         vIMp9VR0FulJ4JVnAx8J54XQbn0vdmZbF/kWBLOM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 122/209] soc: fsl: bman_portals: defer probe after bman's probe
Date:   Tue, 12 Nov 2019 20:48:58 -0500
Message-Id: <20191113015025.9685-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit e0940b34c40e95d1879691d2474d182c57aae0de ]

A crash in bman portal probing could not be triggered (as is the case
with qman portals) but it does make calls [1] into the bman driver so
lets make sure the bman portal probing happens after bman's.

[1]  bman_p_irqsource_add() (in bman) called by:
       init_pcfg() called by:
         bman_portal_probe()

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qbman/bman_portal.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/qbman/bman_portal.c b/drivers/soc/fsl/qbman/bman_portal.c
index 2f71f7df3465a..f9edd28894fda 100644
--- a/drivers/soc/fsl/qbman/bman_portal.c
+++ b/drivers/soc/fsl/qbman/bman_portal.c
@@ -91,7 +91,15 @@ static int bman_portal_probe(struct platform_device *pdev)
 	struct device_node *node = dev->of_node;
 	struct bm_portal_config *pcfg;
 	struct resource *addr_phys[2];
-	int irq, cpu;
+	int irq, cpu, err;
+
+	err = bman_is_probed();
+	if (!err)
+		return -EPROBE_DEFER;
+	if (err < 0) {
+		dev_err(&pdev->dev, "failing probe due to bman probe error\n");
+		return -ENODEV;
+	}
 
 	pcfg = devm_kmalloc(dev, sizeof(*pcfg), GFP_KERNEL);
 	if (!pcfg)
-- 
2.20.1

