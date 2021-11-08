Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA3F44A15E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhKIBJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239277AbhKIBHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C4461A04;
        Tue,  9 Nov 2021 01:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419788;
        bh=hCBZVbn5ACGsSoRa85leu+ceg8jHthpi32UI/d/3jZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYbu7Cd4HkwwqC+HvZdNSrOMcQIdXj3QyhOSnLRFXx3MGKWntFAQ7NuQMi13cLN+s
         T32dxr/kKdpYCT2zH/y8AuPtq4wgmdcOzC2pnDmvRB0OQ5DraA3q+W1sHA7v6hRA/B
         g4ZazjDICbV2Cdn91RurvFerNCzRNTI4wC5p+ozYcRe1eDGpNbJdOwreDOmUvkGJXQ
         GgeoGqkoPTpyI3t/tTsNRGlV58Uo58OijygiBdbWEIIG3GKCD/IE0s8REKFaq6mOXK
         Z7/u/a2+WeP8mgDCS2rgssdVzFRj2RZW2UjNQODvr+4TW+AKUYTPIQeVS6UpvZbOSN
         WvM6pVu/+Vk7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, a.hajda@samsung.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 044/138] media: s5p-mfc: Add checking to s5p_mfc_probe().
Date:   Mon,  8 Nov 2021 12:45:10 -0500
Message-Id: <20211108174644.1187889-44-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit cdfaf4752e6915a4b455ad4400133e540e4dc965 ]

If of_device_get_match_data() return NULL,
then null pointer dereference occurs in  s5p_mfc_init_pm().
The patch adds checking if dev->variant is NULL.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index c763c0a03140c..f336a95432732 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1288,6 +1288,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 
 	dev->variant = of_device_get_match_data(&pdev->dev);
+	if (!dev->variant) {
+		dev_err(&pdev->dev, "Failed to get device MFC hardware variant information\n");
+		return -ENOENT;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
-- 
2.33.0

