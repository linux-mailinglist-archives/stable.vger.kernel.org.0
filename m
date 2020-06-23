Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAB7205F0E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390935AbgFWU3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390919AbgFWU26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:28:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2DA2064B;
        Tue, 23 Jun 2020 20:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944138;
        bh=Cb/1zkzLCwyUr1J7Sf3+9a9YlTM3sRWLJie4afX0Vao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlyfSx802YMWZ3plb8CK21b9/M0sft6EzcdJMYkrjTonWQCwMHvudThpQ/O/rspbn
         mqAKHupE+wZHBrcDAEzHvVGBEcPGqzFbhb8kWm2YkP0gzIj8sRPU+4PIxz2JU5Wdq5
         5b5zHWwErvnjO+xuuwNin//0hDIqz4TjehK6TARQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/314] ASoC: fix incomplete error-handling in img_i2s_in_probe.
Date:   Tue, 23 Jun 2020 21:56:22 +0200
Message-Id: <20200623195347.827249961@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index fdd2c73fd2fac..869fe0068cbd3 100644
--- a/sound/soc/img/img-i2s-in.c
+++ b/sound/soc/img/img-i2s-in.c
@@ -482,6 +482,7 @@ static int img_i2s_in_probe(struct platform_device *pdev)
 	if (IS_ERR(rst)) {
 		if (PTR_ERR(rst) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
+			pm_runtime_put(&pdev->dev);
 			goto err_suspend;
 		}
 
-- 
2.25.1



