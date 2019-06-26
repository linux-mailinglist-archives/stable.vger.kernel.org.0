Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F25256075
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfFZDsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfFZDpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:45:17 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97CAA21738;
        Wed, 26 Jun 2019 03:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520716;
        bh=e6VPy2IePKX0wLD9QIegW2tEtkkOHE5CSxSZjzWV+zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGJ84m0HoIgD/KTo5xHib1E9QNCL64QQx6MFlEDCLmbtCTHjBRXPfF+A0k3pSnUIJ
         E+t8j+YGcce4S1gAw4IRvmmTEgz9iz7iuHPfxxghja80H5NbSLUcA8n4YEzfLw4tne
         HMOAhxbz6KNdqJVYD2crMxpEEKEuHGMdFg4x+mrY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 04/21] ASoC: core: lock client_mutex while removing link components
Date:   Tue, 25 Jun 2019 23:44:49 -0400
Message-Id: <20190626034506.24125-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034506.24125-1-sashal@kernel.org>
References: <20190626034506.24125-1-sashal@kernel.org>
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
index 42c2a3065b77..eb23c237b622 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1258,12 +1258,14 @@ static void soc_remove_link_components(struct snd_soc_card *card,
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

