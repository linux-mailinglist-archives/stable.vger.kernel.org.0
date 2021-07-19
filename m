Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2573CE1A9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242565AbhGSP1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348971AbhGSPZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98AA1601FD;
        Mon, 19 Jul 2021 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710753;
        bh=aJBw8jjhhKbGjyfQ6T+7BADt3YEy5QEkCX5zyzSSdmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAdzdUqvOk/eqe/rD0Jik3onvli+u5Nn9Mm2tBJ21KhCcnsEV1WzMkt8FZesRVRlk
         lSeGAoRHgJ9tpYSAVUdSxwu94yGI4eaeibdINuATZaDQ478IH8lY4nTaDf/pBaSSxa
         znx2udXPqabmP3PdZ802zr715EZxfEMGo97jpoJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/351] ASoC: SOF: topology: fix assignment to use le32_to_cpu
Date:   Mon, 19 Jul 2021 16:50:08 +0200
Message-Id: <20210719144946.580233116@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



