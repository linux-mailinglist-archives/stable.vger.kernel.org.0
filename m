Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A8124DD0E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgHURLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgHUQRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:17:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8759022B4B;
        Fri, 21 Aug 2020 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026632;
        bh=wfyP6ErZoZxY7ltPAxt9V2YaYyKjCJkU6bza5vC6jfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mdwuIRMkVgETb0eextYFGtt7NCh7LodlfucpqonofdDnaGfRFdxmsrUuqIP/MN+p
         MpVCCjEeN8YXvtn/UcE4QCC8jXEol74nKG17vfnwkNMDW5VSyPCBlf/yin2mvMA9Ju
         D9DIJuhCvn++16AHGQli/Hs2DRBGgxA3hFVO/+mk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 06/48] ASoC: img-parallel-out: Fix a reference count leak
Date:   Fri, 21 Aug 2020 12:16:22 -0400
Message-Id: <20200821161704.348164-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161704.348164-1-sashal@kernel.org>
References: <20200821161704.348164-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 6b9fbb073636906eee9fe4d4c05a4f445b9e2a23 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200614033344.1814-1-wu000273@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/img/img-parallel-out.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/img/img-parallel-out.c b/sound/soc/img/img-parallel-out.c
index 5ddbe3a31c2e9..4da49a42e8547 100644
--- a/sound/soc/img/img-parallel-out.c
+++ b/sound/soc/img/img-parallel-out.c
@@ -163,8 +163,10 @@ static int img_prl_out_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	}
 
 	ret = pm_runtime_get_sync(prl->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(prl->dev);
 		return ret;
+	}
 
 	reg = img_prl_out_readl(prl, IMG_PRL_OUT_CTL);
 	reg = (reg & ~IMG_PRL_OUT_CTL_EDGE_MASK) | control_set;
-- 
2.25.1

