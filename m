Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1740D623D3
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389575AbfGHPbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389568AbfGHPbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:31:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F3D21537;
        Mon,  8 Jul 2019 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599861;
        bh=123LvG5HBWrU6fX8TV7jwY6aig2FA9GCYpsfdvH6b/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWrM2T/LYXzQdPZhzpU2NsTOazgmQPeql/rWm4OwOpSH/c9CR45zcQUfuJclbLMdM
         LgsI7+NlUNZ7XFDnpPnLbH7xkmAJAzPxxJ4TCtAlj9IRPrRCOX8WbOV8Hoos2GS2CS
         S0o77fR8Ugb+Plo4rrhtA7ylRo1lD8j9XoD9xraM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 14/96] ASoC: core: lock client_mutex while removing link components
Date:   Mon,  8 Jul 2019 17:12:46 +0200
Message-Id: <20190708150527.154167492@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 34ac3c3eb8f0c07252ceddf0a22dd240e5c91ccb ]

Removing link components results in topology unloading. So,
acquire the client_mutex before removing components in
soc_remove_link_components. This will prevent the lockdep warning
seen when dai links are removed during topology removal.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a7b4fab92f26..a4668a788ed5 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1008,12 +1008,14 @@ static void soc_remove_link_components(struct snd_soc_card *card,
 	struct snd_soc_component *component;
 	struct snd_soc_rtdcom_list *rtdcom;
 
+	mutex_lock(&client_mutex);
 	for_each_rtdcom(rtd, rtdcom) {
 		component = rtdcom->component;
 
 		if (component->driver->remove_order == order)
 			soc_remove_component(component);
 	}
+	mutex_unlock(&client_mutex);
 }
 
 static void soc_remove_dai_links(struct snd_soc_card *card)
-- 
2.20.1



