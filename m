Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447322E3891
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbgL1NL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731898AbgL1NL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:11:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C18720728;
        Mon, 28 Dec 2020 13:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161076;
        bh=LDUSEzgpQCg/tQ503EdAynkOAI60OzN7LY9fFmOsqNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvFCL5Zkv0wLfNVkaUdpdoGUzR5TUnBH9eZhAq/AEElvl8H8UHlTLC0uT55ajMRrz
         dzObOqjqv8S01SuDqK4Aah4zIdPM4mmhctCo35z7TsNPqGHBa/ZHUC7nVztEW0mnJ1
         crbTIFxu3y+17H3rgtOr2ifhwmpB+EZtuzA1FXY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/242] staging: greybus: codecs: Fix reference counter leak in error handling
Date:   Mon, 28 Dec 2020 13:48:17 +0100
Message-Id: <20201228124909.229498820@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index a6d01f0761f32..6ba5a34fcdf29 100644
--- a/drivers/staging/greybus/audio_codec.c
+++ b/drivers/staging/greybus/audio_codec.c
@@ -490,6 +490,7 @@ static int gbcodec_hw_params(struct snd_pcm_substream *substream,
 	if (ret) {
 		dev_err_ratelimited(dai->dev, "%d: Error during set_config\n",
 				    ret);
+		gb_pm_runtime_put_noidle(bundle);
 		mutex_unlock(&codec->lock);
 		return ret;
 	}
@@ -566,6 +567,7 @@ static int gbcodec_prepare(struct snd_pcm_substream *substream,
 		break;
 	}
 	if (ret) {
+		gb_pm_runtime_put_noidle(bundle);
 		mutex_unlock(&codec->lock);
 		dev_err_ratelimited(dai->dev, "set_data_size failed:%d\n",
 				     ret);
-- 
2.27.0



