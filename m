Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DE3259B36
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgIAPVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbgIAPVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:21:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA5E2137B;
        Tue,  1 Sep 2020 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973694;
        bh=PJlJN9iz55FCW+gfWE6Dcvm0SreHsE+AMvFKVq4QXKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0chunCqN/fYAKL2M59uctKqJIzZmpLOyb+eyw4WnX62x/vDQnck/eyOZuJh7HuFJL
         bCkXpvNPEeIEYZ2cOjv4Qp3X84pLRgMnPtCL6gptj6iI4yzhl0mJIuSmGUD/IBkOJy
         ktXkMpUCNv8olDgd8ic9atc4t+u5eKKZ3nxSKqE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/125] ASoC: img: Fix a reference count leak in img_i2s_in_set_fmt
Date:   Tue,  1 Sep 2020 17:09:25 +0200
Message-Id: <20200901150935.094462104@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit c4c59b95b7f7d4cef5071b151be2dadb33f3287b ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200614033749.2975-1-wu000273@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/img/img-i2s-in.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/img/img-i2s-in.c
index c22880aea82a2..7e48c740bf550 100644
--- a/sound/soc/img/img-i2s-in.c
+++ b/sound/soc/img/img-i2s-in.c
@@ -346,8 +346,10 @@ static int img_i2s_in_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	chan_control_mask = IMG_I2S_IN_CH_CTL_CLK_TRANS_MASK;
 
 	ret = pm_runtime_get_sync(i2s->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(i2s->dev);
 		return ret;
+	}
 
 	for (i = 0; i < i2s->active_channels; i++)
 		img_i2s_in_ch_disable(i2s, i);
-- 
2.25.1



