Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8972475A7
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbgHQT0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbgHQPdu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B956120709;
        Mon, 17 Aug 2020 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678430;
        bh=aiYRv65Y3QYFkYEbYpsjnGsAGZP+8qIm7BC1IX6bIaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwe2sb4cDLMpVJefaUaNFIKefsED/3V4/LdeqRqGt0x3wKZMA/afen3QTqSqfr3eu
         lNQgx2dKLxXHu/r1J6kDoSW+Vj5EgbH4zvngLVfrt7KTCXJMrk6HywjLK/Y0Af61gM
         hsplbw1bbub+EMEC5RqUGlf0NG/gfnIU9OA1N/sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 332/464] ASoC: soc-core: Fix regression causing sysfs entries to disappear
Date:   Mon, 17 Aug 2020 17:14:45 +0200
Message-Id: <20200817143849.691239925@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5c74c9d34aec1ac756de6979dd5580096aba8643 ]

The allocation order of things in soc_new_pcm_runtime was changed to
move the device_register before the allocation of the rtd structure.
This was to allow the rtd allocation to be managed by devm. However
currently the sysfs entries are added by device_register and their
visibility depends on variables within the rtd structure, this causes
the pmdown_time and dapm_widgets sysfs entries to be missing for all
rtds.

Correct this issue by manually calling device_add_groups after the
appropriate information is available.

Fixes: d918a37610b1 ("ASoC: soc-core: tidyup soc_new_pcm_runtime() alloc order")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200730120715.637-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 2b8abf88ec603..f1d641cd48da9 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -446,7 +446,6 @@ static struct snd_soc_pcm_runtime *soc_new_pcm_runtime(
 
 	dev->parent	= card->dev;
 	dev->release	= soc_release_rtd_dev;
-	dev->groups	= soc_dev_attr_groups;
 
 	dev_set_name(dev, "%s", dai_link->name);
 
@@ -503,6 +502,10 @@ static struct snd_soc_pcm_runtime *soc_new_pcm_runtime(
 	/* see for_each_card_rtds */
 	list_add_tail(&rtd->list, &card->rtd_list);
 
+	ret = device_add_groups(dev, soc_dev_attr_groups);
+	if (ret < 0)
+		goto free_rtd;
+
 	return rtd;
 
 free_rtd:
-- 
2.25.1



