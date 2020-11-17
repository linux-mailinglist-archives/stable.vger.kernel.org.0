Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D062B62AE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgKQNac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731907AbgKQNa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68C9621534;
        Tue, 17 Nov 2020 13:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619828;
        bh=JkKHH3T7F7wPKsUnBxJhjsNXKIhHvhpdq6u4oezFD4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAWpQ3V4UwInCa7m5f2oy5fnBlGewlsnVbPZz8WK3gflxmq4SSqIGfTrPxNiUYw0D
         M5wxJoGz0g8DpQ/RDY1Eb3HRu/eebp2ZQEfQa2CBUKiGKMbY8Wx8ibVFPu+GGYJ9gP
         GyA5YwyJNyyylCSQllHj4gxgUZqeNFE2bP4D4Y4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 018/255] ASoC: codecs: wcd934x: Set digital gain range correctly
Date:   Tue, 17 Nov 2020 14:02:38 +0100
Message-Id: <20201117122139.829842712@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit fc0522bbe02fa4beb95c0514ace66b585616f111 ]

digital gain range is -84dB min to 40dB max, however this was not
correctly specified in the range.

Fix this by with correct range!

Fixes: 1cde8b822332 ("ASoC: wcd934x: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20201028154340.17090-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index 35697b072367a..40f682f5dab8b 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -551,7 +551,7 @@ struct wcd_iir_filter_ctl {
 	struct soc_bytes_ext bytes_ext;
 };
 
-static const DECLARE_TLV_DB_SCALE(digital_gain, 0, 1, 0);
+static const DECLARE_TLV_DB_SCALE(digital_gain, -8400, 100, -8400);
 static const DECLARE_TLV_DB_SCALE(line_gain, 0, 7, 1);
 static const DECLARE_TLV_DB_SCALE(analog_gain, 0, 25, 1);
 static const DECLARE_TLV_DB_SCALE(ear_pa_gain, 0, 150, 0);
-- 
2.27.0



