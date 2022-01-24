Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A02B499A69
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354417AbiAXVnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46408 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454580AbiAXVdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 200F3B8121C;
        Mon, 24 Jan 2022 21:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51206C340E4;
        Mon, 24 Jan 2022 21:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059986;
        bh=L5fMBsQ4GFTUWDax+L1PtBdZ0vB16WfrrFYjYR1GER4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlZMnhP06SX2RZT2XsycRtsaAS3NL6anW+Vwd4Puv0IO/qbw8asMlu8v9jFbIVHHr
         JuYdXkjG0JvRi5zO5Il66rJAKt3qJtlGI6jPnPy4J+mUrMceTWXSQblIC4r2m4nu6z
         eMENmvbW4iDLWptMHtO8twOlWtBb/xYnHyJmstK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0768/1039] ASoC: SOF: ipc: Add null pointer check for substream->runtime
Date:   Mon, 24 Jan 2022 19:42:37 +0100
Message-Id: <20220124184151.127977893@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>

[ Upstream commit 182b682b9ab1348e07ea1bf9d8f2505cc67f9237 ]

When pcm stream is stopped "substream->runtime" pointer will be set
to NULL by ALSA core. In case host received an ipc msg from firmware
of type IPC_STREAM_POSITION after pcm stream is stopped, there will
be kernel NULL pointer exception in ipc_period_elapsed(). This patch
fixes it by adding NULL pointer check for "substream->runtime".

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20211216232422.345164-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index e6c53c6c470e4..ca30c506a0fd6 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -547,7 +547,8 @@ static void ipc_period_elapsed(struct snd_sof_dev *sdev, u32 msg_id)
 
 	if (spcm->pcm.compress)
 		snd_sof_compr_fragment_elapsed(stream->cstream);
-	else if (!stream->substream->runtime->no_period_wakeup)
+	else if (stream->substream->runtime &&
+		 !stream->substream->runtime->no_period_wakeup)
 		/* only inform ALSA for period_wakeup mode */
 		snd_sof_pcm_period_elapsed(stream->substream);
 }
-- 
2.34.1



