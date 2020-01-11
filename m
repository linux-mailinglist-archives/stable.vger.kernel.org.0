Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329C4137FC9
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgAKKXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:23:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730884AbgAKKXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:23:03 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B1A7205F4;
        Sat, 11 Jan 2020 10:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738183;
        bh=ZWtIO+a0vaQunMSWxVY3ld+/seCZC51wG2H3XXUbHJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTvuG5gjkjFk3DY60UxtbNW0wBENNpH4D1M1HXIGhA6njYJh0T1RIP40bfz9y7dzP
         xO07GDvLWYwfkieMpZJhY+8f6PqlAUyUpA4/UUMfWirv3axXFy8r5ZeGAno5NSc8LW
         f4kA53JblLYwsbbqnY31Tk+73/y6dm3BDV3ZBScQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/165] ASoC: topology: Check return value for snd_soc_add_dai_link()
Date:   Sat, 11 Jan 2020 10:49:24 +0100
Message-Id: <20200111094924.881167802@linuxfoundation.org>
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

[ Upstream commit 76d2703649321c296df7ec0dafd50add96215de4 ]

snd_soc_add_dai_link() might fail. This situation occurs for
instance in a very specific use case where a PCM device and a
Back End DAI link are given identical names in the topology.
When this happens, soc_new_pcm_runtime() fails and then
snd_soc_add_dai_link() returns -ENOMEM when called from
soc_tplg_fe_link_create(). Because of that, the link will not
get added into the card list, so any attempt to remove it later
ends up in a panic.

Fix that by checking the return status and free the memory in case
of an error.

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191210003939.15752-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 0fd032914a31..c92e360d27b8 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1918,11 +1918,13 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
 	ret = soc_tplg_dai_link_load(tplg, link, NULL);
 	if (ret < 0) {
 		dev_err(tplg->comp->dev, "ASoC: FE link loading failed\n");
-		kfree(link->name);
-		kfree(link->stream_name);
-		kfree(link->cpus->dai_name);
-		kfree(link);
-		return ret;
+		goto err;
+	}
+
+	ret = snd_soc_add_dai_link(tplg->comp->card, link);
+	if (ret < 0) {
+		dev_err(tplg->comp->dev, "ASoC: adding FE link failed\n");
+		goto err;
 	}
 
 	link->dobj.index = tplg->index;
@@ -1930,8 +1932,13 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
 	link->dobj.type = SND_SOC_DOBJ_DAI_LINK;
 	list_add(&link->dobj.list, &tplg->comp->dobj_list);
 
-	snd_soc_add_dai_link(tplg->comp->card, link);
 	return 0;
+err:
+	kfree(link->name);
+	kfree(link->stream_name);
+	kfree(link->cpus->dai_name);
+	kfree(link);
+	return ret;
 }
 
 /* create a FE DAI and DAI link from the PCM object */
-- 
2.20.1



