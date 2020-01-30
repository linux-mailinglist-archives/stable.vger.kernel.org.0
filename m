Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA7514E19B
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbgA3Spw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731095AbgA3Spv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBE01205F4;
        Thu, 30 Jan 2020 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409951;
        bh=j+yLi+3j4hwP60s9Q2eMbBz0UexJHV/VUghA6zCWvK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0G9WHuBruY7cPLJtfljccyQE3NXDMY7via9op6+OD/zkxXxcMqV51wGkqs3emYhf
         UoZ6tl1hkNfjGHlJjOUOZjJxzD74p4LvUpllMf0bLYzrR7K3Wi9HVezJWU5DlUbq9w
         9ERvmQzE9uEPehsxt0343GX7nBzodYPKIxePEwuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/110] ASoC: topology: Prevent use-after-free in snd_soc_get_pcm_runtime()
Date:   Thu, 30 Jan 2020 19:38:33 +0100
Message-Id: <20200130183621.853126337@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tarcatu <dragos_tarcatu@mentor.com>

[ Upstream commit dd836ddf4e4e1c7f1eb2ae44783ccd70872ef24e ]

remove_link() is currently calling snd_soc_remove_dai_link() after
it has already freed the memory for the link name. But this is later
read from snd_soc_get_pcm_runtime() causing a KASAN use-after-free
warning. Reorder the cleanups to fix this issue.

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20191204210447.11701-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index fd2d22ddc81b0..7ccbca47240d7 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -548,12 +548,12 @@ static void remove_link(struct snd_soc_component *comp,
 	if (dobj->ops && dobj->ops->link_unload)
 		dobj->ops->link_unload(comp, dobj);
 
+	list_del(&dobj->list);
+	snd_soc_remove_dai_link(comp->card, link);
+
 	kfree(link->name);
 	kfree(link->stream_name);
 	kfree(link->cpus->dai_name);
-
-	list_del(&dobj->list);
-	snd_soc_remove_dai_link(comp->card, link);
 	kfree(link);
 }
 
-- 
2.20.1



