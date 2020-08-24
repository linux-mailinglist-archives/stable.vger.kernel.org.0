Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F16024F972
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgHXImm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgHXImh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:42:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A312075B;
        Mon, 24 Aug 2020 08:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258556;
        bh=22Rhiqu71rCRioEpH8pUYQ6I0BMWTCOHnKEzfT7deRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzIzEVdB2t1C+EMGH55u+bh0CzAnAEOZI4y/FWJxEyrQ6VdD4Z3YVqYfTwVqgKcvk
         XBBRBF7wZrVgxBR1nr2IQdIXs5i/am7MH3/yUG4EkGU8qfD32RMtGACPWJMKfBHqV7
         tEvr5Q45FsW4yCTLuiWTuh9PWOQHrBpzPzGnd9jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 087/124] ASoC: intel: Fix memleak in sst_media_open
Date:   Mon, 24 Aug 2020 10:30:21 +0200
Message-Id: <20200824082413.693679686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 062fa09f44f4fb3776a23184d5d296b0c8872eb9 ]

When power_up_sst() fails, stream needs to be freed
just like when try_module_get() fails. However, current
code is returning directly and ends up leaking memory.

Fixes: 0121327c1a68b ("ASoC: Intel: mfld-pcm: add control for powering up/down dsp")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200813084112.26205-1-dinghao.liu@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 82f2b6357778d..a3cb05d925846 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -331,7 +331,7 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	ret_val = power_up_sst(stream);
 	if (ret_val < 0)
-		return ret_val;
+		goto out_power_up;
 
 	/* Make sure, that the period size is always even */
 	snd_pcm_hw_constraint_step(substream->runtime, 0,
@@ -340,8 +340,9 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 	return snd_pcm_hw_constraint_integer(runtime,
 			 SNDRV_PCM_HW_PARAM_PERIODS);
 out_ops:
-	kfree(stream);
 	mutex_unlock(&sst_lock);
+out_power_up:
+	kfree(stream);
 	return ret_val;
 }
 
-- 
2.25.1



