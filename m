Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6D72E3AF6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404507AbgL1Nnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403793AbgL1Nnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 671172064B;
        Mon, 28 Dec 2020 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162989;
        bh=nr0VlxGqmc+nQNVKeKswqnm56odsGdNOXV9JQM4Mvyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zI3uF/WSoP2/5WpIku0Vsoc+2RxOZwd+H9qTkYxDj+qQQAlK62NFqwgaAc5XJbVY1
         35sQfT2NN3UFnN2jzgTAMAqetoCqE8IE6oNf6YDoRV4ir9l663SWdIwP+gcYnWyFAs
         S/mmyV1tPWtMBbJds49Epoit/dsGlfzAzS3Y8gLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/453] staging: greybus: codecs: Fix reference counter leak in error handling
Date:   Mon, 28 Dec 2020 13:46:06 +0100
Message-Id: <20201228124943.467899093@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 3952659a6108f77a0d062d8e8487bdbdaf52a66c ]

gb_pm_runtime_get_sync has increased the usage counter of the device here.
Forgetting to call gb_pm_runtime_put_noidle will result in usage counter
leak in the error branch of (gbcodec_hw_params and gbcodec_prepare). We
fixed it by adding it.

Fixes: c388ae7696992 ("greybus: audio: Update pm runtime support in dai_ops callback")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201109131347.1725288-2-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_codec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/greybus/audio_codec.c b/drivers/staging/greybus/audio_codec.c
index 08746c85dea6d..3259bf02ba25e 100644
--- a/drivers/staging/greybus/audio_codec.c
+++ b/drivers/staging/greybus/audio_codec.c
@@ -489,6 +489,7 @@ static int gbcodec_hw_params(struct snd_pcm_substream *substream,
 	if (ret) {
 		dev_err_ratelimited(dai->dev, "%d: Error during set_config\n",
 				    ret);
+		gb_pm_runtime_put_noidle(bundle);
 		mutex_unlock(&codec->lock);
 		return ret;
 	}
@@ -565,6 +566,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
 		break;
 	}
 	if (ret) {
+		gb_pm_runtime_put_noidle(bundle);
 		mutex_unlock(&codec->lock);
 		dev_err_ratelimited(dai->dev, "set_data_size failed:%d\n",
 				    ret);
-- 
2.27.0



