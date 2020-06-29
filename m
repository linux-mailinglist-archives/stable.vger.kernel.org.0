Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72E320E724
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404635AbgF2Vxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgF2Sfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056C0246B0;
        Mon, 29 Jun 2020 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444004;
        bh=3r3v1nvR0vOVb62KV20dOeGyuaTp4CmZLYUwsK6azdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hRByP1r3zKdNFki1vhKWBUaa+uopuDv7t9LAe6Ts6drBrmmLgdqLIRu0XG+KW2Zu
         18D4+eS7e+r16F8KvyZPFYY53ZC5SQGR9keOiveiWTxhwSjKgPunnVT0QnAe1Uq0Vn
         yh+RRDT1l6PcHA4qWrfN1J62yr9ymzVVWz7oxGMg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 110/265] ASoC: soc-pcm: fix checks for multi-cpu FE dailinks
Date:   Mon, 29 Jun 2020 11:15:43 -0400
Message-Id: <20200629151818.2493727-111-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 96bf62f018f40cb5d4e4bed95e50fd990a2354af ]

soc_dpcm_fe_runtime_update() is called for all dailinks, and we want
to first discard all back-ends, then deal with front-ends.

The existing code first reports an error with multi-cpu front-ends,
and that check needs to be moved after we know that we are dealing
with a front-end.

Fixes: 6e1276a5e613d ('ASoC: Return error if the function does not support multi-cpu')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
BugLink: https://github.com/thesofproject/linux/issues/1970
Link: https://lore.kernel.org/r/20200612203507.25621-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 39ce61c5b8744..fde097a7aad32 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2749,15 +2749,15 @@ static int soc_dpcm_fe_runtime_update(struct snd_soc_pcm_runtime *fe, int new)
 	int count, paths;
 	int ret;
 
+	if (!fe->dai_link->dynamic)
+		return 0;
+
 	if (fe->num_cpus > 1) {
 		dev_err(fe->dev,
 			"%s doesn't support Multi CPU yet\n", __func__);
 		return -EINVAL;
 	}
 
-	if (!fe->dai_link->dynamic)
-		return 0;
-
 	/* only check active links */
 	if (!fe->cpu_dai->active)
 		return 0;
-- 
2.25.1

