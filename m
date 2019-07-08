Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014B1624C9
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbfGHPVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387741AbfGHPVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:21:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2947B216E3;
        Mon,  8 Jul 2019 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599290;
        bh=uHLaqiSsQAcBq1LXrmM+IfqwHY3/6Ig7VQhPmEKMlxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/8tFQobbttNh9rg9ERvv6iUvjW+euEyyPqli6zCD2kve5dwG4TCgvL3iu3jnXDSl
         uvch7HfiShI/5H59Zcoe0+4oUeAxH5P/Y+UN6r+kLpHOSwE6uXD+/g5Q7CqlHfU2h0
         CEUZjAGVn7puMhadtX+ypAEy7fw09Gxi9qrlj8+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libin Yang <libin.yang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/102] ASoC: soc-pcm: BE dai needs prepare when pause release after resume
Date:   Mon,  8 Jul 2019 17:13:00 +0200
Message-Id: <20190708150529.925684682@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5087a8f17df868601cd7568299e91c28086d2b45 ]

If playback/capture is paused and system enters S3, after system returns
from suspend, BE dai needs to call prepare() callback when playback/capture
is released from pause if RESUME_INFO flag is not set.

Currently, the dpcm_be_dai_prepare() function will block calling prepare()
if the pcm is in SND_SOC_DPCM_STATE_PAUSED state. This will cause the
following test case fail if the pcm uses BE:

playback -> pause -> S3 suspend -> S3 resume -> pause release

The playback may exit abnormally when pause is released because the BE dai
prepare() is not called.

This patch allows dpcm_be_dai_prepare() to call dai prepare() callback in
SND_SOC_DPCM_STATE_PAUSED state.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 1dbcdc99dbe3..1d00f6e894ef 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2247,7 +2247,8 @@ int dpcm_be_dai_prepare(struct snd_soc_pcm_runtime *fe, int stream)
 
 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP) &&
-		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_SUSPEND))
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_SUSPEND) &&
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
 			continue;
 
 		dev_dbg(be->dev, "ASoC: prepare BE %s\n",
-- 
2.20.1



