Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75928F5700
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388112AbfKHTP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732707AbfKHTFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:05:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587E6218AE;
        Fri,  8 Nov 2019 19:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239906;
        bh=XD1D1VT5cOjCVBZpol8U0nDBMsixK5DchGwMkIdXBi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2pTp49YaFCkZsRH1/N9oIgd3ezlEEzA7hzDrc1wQAF96W4F9VLEGErgLupuBAJ6g
         U45NrUaeaYSCjqwJf2RKWElEB5ui99MzxnRHUzGb/QMDkQWCYgJZEJ5Z17r1ZV6zjZ
         lt/85IlBXcIJ17Tm8emvJ5qS5A9QXDlYc3nvht6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 022/140] ASoc: rockchip: i2s: Fix RPM imbalance
Date:   Fri,  8 Nov 2019 19:49:10 +0100
Message-Id: <20191108174904.352546010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit b1e620e7d32f5aad5353cc3cfc13ed99fea65d3a ]

If rockchip_pcm_platform_register() fails, e.g. upon deferring to wait
for an absent DMA channel, we return without disabling RPM, which makes
subsequent re-probe attempts scream with errors about the unbalanced
enable. Don't do that.

Fixes: ebb75c0bdba2 ("ASoC: rockchip: i2s: Adjust devm usage")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/bcb12a849a05437fb18372bc7536c649b94bdf07.1570029862.git.robin.murphy@arm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 88ebaf6e1880a..a0506e554c98b 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -674,7 +674,7 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 	ret = rockchip_pcm_platform_register(&pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not register PCM\n");
-		return ret;
+		goto err_suspend;
 	}
 
 	return 0;
-- 
2.20.1



