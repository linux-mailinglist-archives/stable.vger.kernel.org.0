Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E0206270
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403843AbgFWVB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392040AbgFWUjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:39:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B885B2168B;
        Tue, 23 Jun 2020 20:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944758;
        bh=rrB2UF7V1H+mQ2K95Cfve0V6X5yS/Ka9557uHo/F0LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGcUjPbC3/LInksP/5cdg/nhQykYoVRVQpG9iLp2hzFHQZAJxU3QzxKMZzDa36qdn
         W4bez8LPTSbbrjjacOTfOI+X8dhv7EjSaPzqccwZRQ9F40bCDz6WmmcLvJU7htub/9
         UB/qcmmhsE/6P/w4B0qHMTIPahAUspkgqnm4Is1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/206] ASoC: fix incomplete error-handling in img_i2s_in_probe.
Date:   Tue, 23 Jun 2020 21:57:21 +0200
Message-Id: <20200623195322.506414904@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 25bf943e4e7b47282bd86ae7d39e039217ebb007 ]

Function "pm_runtime_get_sync()" is not handled by "pm_runtime_put()"
if "PTR_ERR(rst) == -EPROBE_DEFER". Fix this issue by adding
"pm_runtime_put()" into this error path.

Fixes: f65bb92ca12e ("ASoC: img-i2s-in: Add runtime PM")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200525055011.31925-1-wu000273@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/img/img-i2s-in.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/img/img-i2s-in.c
index 388cefd7340ab..c22880aea82a2 100644
--- a/sound/soc/img/img-i2s-in.c
+++ b/sound/soc/img/img-i2s-in.c
@@ -485,6 +485,7 @@ static int img_i2s_in_probe(struct platform_device *pdev)
 	if (IS_ERR(rst)) {
 		if (PTR_ERR(rst) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
+			pm_runtime_put(&pdev->dev);
 			goto err_suspend;
 		}
 
-- 
2.25.1



