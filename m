Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4AC3C2CF8
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhGJCVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232075AbhGJCVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A140613D9;
        Sat, 10 Jul 2021 02:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883504;
        bh=aJBw8jjhhKbGjyfQ6T+7BADt3YEy5QEkCX5zyzSSdmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbeSHMbFKwG9vTmpoeMYWRwnqILqLhs6JJWbV2cyOLZsj5z5c+rv2W/R2YoQVwFpw
         Y0xshWvAS+Yx9UUE8XCnV2qAuz5GRsz56N/GLbzgv/MFFTxEJEQlRXGSnTHzAeNY+6
         Mxf/r3/Da9bX3RmwJQqLpwDQt0MW6rX2Hap2A0wfJr0L/CdKl4Kn9UqEEA/L0UUPgO
         xsNmOxvvQRXUhFTR31igKbA0VvFljGkZBs4tWlTqC9xQNraAIFLIcJDQaj3mE4QQBv
         R7OoG8ALjMVqv7mI2cxucfgAOX+seGCdKBwAXlXqqsznCL6NAkMQetEGtM27H7haOR
         MNERr++s/xFXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 025/114] ASoC: SOF: topology: fix assignment to use le32_to_cpu
Date:   Fri,  9 Jul 2021 22:16:19 -0400
Message-Id: <20210710021748.3167666-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaska Uimonen <jaska.uimonen@linux.intel.com>

[ Upstream commit ccaea61a8d1b8180cc3c470e383381884e4bc1f2 ]

Fix sparse warning by using le32_to_cpu.

Signed-off-by: Jaska Uimonen <jaska.uimonen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210521092804.3721324-6-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 59abcfc9bd55..cb16b2bd8c21 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -3335,7 +3335,7 @@ static int sof_link_load(struct snd_soc_component *scomp, int index,
 	/* Copy common data to all config ipc structs */
 	for (i = 0; i < num_conf; i++) {
 		config[i].hdr.cmd = SOF_IPC_GLB_DAI_MSG | SOF_IPC_DAI_CONFIG;
-		config[i].format = hw_config[i].fmt;
+		config[i].format = le32_to_cpu(hw_config[i].fmt);
 		config[i].type = common_config.type;
 		config[i].dai_index = common_config.dai_index;
 	}
-- 
2.30.2

