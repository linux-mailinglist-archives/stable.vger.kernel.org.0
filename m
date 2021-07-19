Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3133CDEC6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344524AbhGSPGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344926AbhGSPDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB2E4610A5;
        Mon, 19 Jul 2021 15:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709386;
        bh=AoD/7CWDXvR+9ak/sKEZmG77jR/GQC1p+n/HlENlaC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjb5mn8NBen9gjyIyYE+TyvO96zhll4EgADxSLypXIiyrf98xfzTBqkwhHF3/Sf9E
         N2vQhaDVJE6VDg18C6oAJZi0K+QAMSmsk6TH080n4QX6cKsgtvaPonYuGiUMBbVQKx
         pleX3iwaIpRa9eOwQYmzgDmj4A9Rw8tdlTjaEbpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 330/421] ALSA: ac97: fix PM reference leak in ac97_bus_remove()
Date:   Mon, 19 Jul 2021 16:52:21 +0200
Message-Id: <20210719144957.732287675@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit a38e93302ee25b2ca6f4ee76c6c974cf3637985e ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Link: https://lore.kernel.org/r/20210524093811.612302-1-yuyufen@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/ac97/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/ac97/bus.c b/sound/ac97/bus.c
index ca50ff444796..d8b227e6d4cf 100644
--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -523,7 +523,7 @@ static int ac97_bus_remove(struct device *dev)
 	struct ac97_codec_driver *adrv = to_ac97_driver(dev->driver);
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



