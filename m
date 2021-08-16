Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C883ED5E1
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbhHPNPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239808AbhHPNOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58505632CD;
        Mon, 16 Aug 2021 13:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119497;
        bh=RtQy+kpaH6nhz6lcFr4SyDCP5+ld9E5irSH2O1pX65Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UycebPd+mGoFtUxDv0Bmi1CMIIwAbxD9aWH2b41ek9HO/4tKrYpN6K7GezJePF6cs
         4JY7JE/nox9GJzJ2nO4XmSVzKwAFJwrBU7vfX2fJyG6narvH/bv7msAzELXpTqD8Po
         STVAn48rxnhtld6Vvzmqd9P92PZJTwFPqMnCNJ5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 049/151] ASoC: SOF: Intel: hda-ipc: fix reply size checking
Date:   Mon, 16 Aug 2021 15:01:19 +0200
Message-Id: <20210816125445.692131336@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

[ Upstream commit 973b393fdf073a4ebd8d82ef6edea99fedc74af9 ]

Checking that two values don't have common bits makes no sense,
strict equality is meant.

Fixes: f3b433e4699f  ("ASoC: SOF: Implement Probe IPC API")
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210802151749.15417-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-ipc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-ipc.c b/sound/soc/sof/intel/hda-ipc.c
index c91aa951df22..acfeca42604c 100644
--- a/sound/soc/sof/intel/hda-ipc.c
+++ b/sound/soc/sof/intel/hda-ipc.c
@@ -107,8 +107,8 @@ void hda_dsp_ipc_get_reply(struct snd_sof_dev *sdev)
 	} else {
 		/* reply correct size ? */
 		if (reply.hdr.size != msg->reply_size &&
-			/* getter payload is never known upfront */
-			!(reply.hdr.cmd & SOF_IPC_GLB_PROBE)) {
+		    /* getter payload is never known upfront */
+		    ((reply.hdr.cmd & SOF_GLB_TYPE_MASK) != SOF_IPC_GLB_PROBE)) {
 			dev_err(sdev->dev, "error: reply expected %zu got %u bytes\n",
 				msg->reply_size, reply.hdr.size);
 			ret = -EINVAL;
-- 
2.30.2



