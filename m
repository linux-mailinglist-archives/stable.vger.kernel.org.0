Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B574560A8
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfFZDnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbfFZDnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:49 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0A9D205ED;
        Wed, 26 Jun 2019 03:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520628;
        bh=2lP2cVHnR8w/VwbuHUPBtgIPPo8PiZCzItqKieFIUHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5vNnoSt2g8qNsrXaKOXjUPf4q6TwZ/Hitdd2RV8frqNbcKI2yOBMeSJjdOUTHf1E
         0HJLqRe/ME+Sk4FaOz408DBFKNZvwou/oOTpZg/mrtU30umlm4suAAHynI1Es7MPqW
         GnLK029W+hO9yUpa8SrgsJENnEZ3jQfajB2T58sQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 06/34] ASoC: core: lock client_mutex while removing link components
Date:   Tue, 25 Jun 2019 23:43:07 -0400
Message-Id: <20190626034335.23767-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034335.23767-1-sashal@kernel.org>
References: <20190626034335.23767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

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
index 62aa320c2070..71e13f8f2579 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -979,12 +979,14 @@ static void soc_remove_link_components(struct snd_soc_card *card,
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

