Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32447137FE3
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbgAKKXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730789AbgAKKXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:23:08 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32DF20880;
        Sat, 11 Jan 2020 10:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738187;
        bh=M7HQ865n/QAKmQEHDY5qkcuhxcXhnjjq5IZ81ggnCXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lygiZJS6tQH6r0a+38KBFebQN5BneMAYIyj33x2rttdNQ0pCoO3gCjjt6z3MHo6Og
         N8nIGSoShlMxS4Sd3JMIaAJXBPsDWxA9anaoRoiKUAOUStg7NzsRZ96Cben57wfWTM
         rFP/1vji9+6yx0vXWxo6Ztvl2U6Uy0PrGxqCqsYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/165] ASoC: topology: Check return value for soc_tplg_pcm_create()
Date:   Sat, 11 Jan 2020 10:49:25 +0100
Message-Id: <20200111094925.134358232@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tarcatu <dragos_tarcatu@mentor.com>

[ Upstream commit a3039aef52d9ffeb67e9211899cd3e8a2953a01f ]

The return value of soc_tplg_pcm_create() is currently not checked
in soc_tplg_pcm_elems_load(). If an error is to occur there, the
topology ignores it and continues loading.

Fix that by checking the status and rejecting the topology on error.

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191210003939.15752-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index c92e360d27b8..fd2d22ddc81b 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2031,6 +2031,7 @@ static int soc_tplg_pcm_elems_load(struct soc_tplg *tplg,
 	int size;
 	int i;
 	bool abi_match;
+	int ret;
 
 	count = le32_to_cpu(hdr->count);
 
@@ -2072,7 +2073,12 @@ static int soc_tplg_pcm_elems_load(struct soc_tplg *tplg,
 		}
 
 		/* create the FE DAIs and DAI links */
-		soc_tplg_pcm_create(tplg, _pcm);
+		ret = soc_tplg_pcm_create(tplg, _pcm);
+		if (ret < 0) {
+			if (!abi_match)
+				kfree(_pcm);
+			return ret;
+		}
 
 		/* offset by version-specific struct size and
 		 * real priv data size
-- 
2.20.1



