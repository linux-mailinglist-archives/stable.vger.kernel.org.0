Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DB6FA596
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfKMBwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbfKMBwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07570204EC;
        Wed, 13 Nov 2019 01:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609943;
        bh=rmpRqWBuUsMLm26OG9t+wtXYQizGsK/WZIguKaUORQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntw+5uXi9WwjEbwmnkRwISsrppVBE7Sf55HzVu9/HsASwrcEWCL71pJFYo+BQjTA+
         G+K8isL7F1Uf0vGT15fVBOSz2igZ0EOUJwQ3IsrDZFAjOyMy5kCqvyRZZFbLl0wdK+
         v183ha0d/Sr2J8MA0EOvb9V/z/uO3hldFntMnay8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 083/209] ASoC: qdsp6: q6asm-dai: checking NULL vs IS_ERR()
Date:   Tue, 12 Nov 2019 20:48:19 -0500
Message-Id: <20191113015025.9685-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8e9f7265eda9f3a662ca1ca47a69042a7840735b ]

The q6asm_audio_client_alloc() doesn't return NULL, it returns error
pointers.

Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm-dai.c b/sound/soc/qcom/qdsp6/q6asm-dai.c
index 9db9a2944ef26..c1a7d376a3fea 100644
--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -319,10 +319,11 @@ static int q6asm_dai_open(struct snd_pcm_substream *substream)
 	prtd->audio_client = q6asm_audio_client_alloc(dev,
 				(q6asm_cb)event_handler, prtd, stream_id,
 				LEGACY_PCM_MODE);
-	if (!prtd->audio_client) {
+	if (IS_ERR(prtd->audio_client)) {
 		pr_info("%s: Could not allocate memory\n", __func__);
+		ret = PTR_ERR(prtd->audio_client);
 		kfree(prtd);
-		return -ENOMEM;
+		return ret;
 	}
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-- 
2.20.1

