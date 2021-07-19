Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1D3CDDCB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245476AbhGSPAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343565AbhGSO7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1222061403;
        Mon, 19 Jul 2021 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709010;
        bh=xs/vGRmgrbve3NJDPy92AzWDKPEP8jA6/py5AVjkca0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIoFbHdnML/ISX3lDYkdmQjPlXSCk5f3yfoB7EqeYmfwllLBvRdzSssGlp9txwHr7
         CwOeIFTFFiNdHT2T+xa86KSca6ioAQBb+g7w2Ea51rz6P5VS58NGxmMu1msb9dGzA0
         H5Epr5bPbwWa86ALpgQRNAgJL+/Jds5XH1qdxMuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/421] ASoC: hisilicon: fix missing clk_disable_unprepare() on error in hi6210_i2s_startup()
Date:   Mon, 19 Jul 2021 16:49:56 +0200
Message-Id: <20210719144952.842393481@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 375904e3931955fcf0a847f029b2492a117efc43 ]

After calling clk_prepare_enable(), clk_disable_unprepare() need
be called when calling clk_set_rate() failed.

Fixes: 0bf750f4cbe1 ("ASoC: hisilicon: Add hi6210 i2s audio driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210518044514.607010-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/hisilicon/hi6210-i2s.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/hisilicon/hi6210-i2s.c b/sound/soc/hisilicon/hi6210-i2s.c
index 53344a3b7a60..864718ef874f 100644
--- a/sound/soc/hisilicon/hi6210-i2s.c
+++ b/sound/soc/hisilicon/hi6210-i2s.c
@@ -110,18 +110,15 @@ static int hi6210_i2s_startup(struct snd_pcm_substream *substream,
 
 	for (n = 0; n < i2s->clocks; n++) {
 		ret = clk_prepare_enable(i2s->clk[n]);
-		if (ret) {
-			while (n--)
-				clk_disable_unprepare(i2s->clk[n]);
-			return ret;
-		}
+		if (ret)
+			goto err_unprepare_clk;
 	}
 
 	ret = clk_set_rate(i2s->clk[CLK_I2S_BASE], 49152000);
 	if (ret) {
 		dev_err(i2s->dev, "%s: setting 49.152MHz base rate failed %d\n",
 			__func__, ret);
-		return ret;
+		goto err_unprepare_clk;
 	}
 
 	/* enable clock before frequency division */
@@ -173,6 +170,11 @@ static int hi6210_i2s_startup(struct snd_pcm_substream *substream,
 	hi6210_write_reg(i2s, HII2S_SW_RST_N, val);
 
 	return 0;
+
+err_unprepare_clk:
+	while (n--)
+		clk_disable_unprepare(i2s->clk[n]);
+	return ret;
 }
 
 static void hi6210_i2s_shutdown(struct snd_pcm_substream *substream,
-- 
2.30.2



