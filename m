Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C493C2D09
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhGJCVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232277AbhGJCVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEE87613BE;
        Sat, 10 Jul 2021 02:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883514;
        bh=psjiZPoJqTbIx9wY8pQaLI33HJVWFseOA6R/5ygYdO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SG0f8xiiuz8y8/650POICuvLZ1vRS9ekdqPPhvevvwejdukf6Q12DP4s8439PNuQ7
         zJgWOoripkh22akuukxsuCYIrc7AfcDh5aY6H5l4AzXJ4XQCrmaHS4TnHBM2ShIWH2
         UdB3Dh1cctvjiptKIv2M3AuRoFHvEDDLn+ddOE3faYE8BKOsJYUTc2Xv9cX5EhBOYj
         IODffDLy8T8AX/wTPWaFUL/upkBK1NMq6qtepq1kBPM3LQdW1A7VbbPAcsCzMYQXTe
         1VH9cxjx9ITS5pGDCvJ7xzPNhsjm2EnXvqe6JJwvjSF1BiLluVoQfmux1BOaaoqYLB
         2SirhZdwSBBpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufen Yu <yuyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 033/114] ALSA: ac97: fix PM reference leak in ac97_bus_remove()
Date:   Fri,  9 Jul 2021 22:16:27 -0400
Message-Id: <20210710021748.3167666-33-sashal@kernel.org>
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
index d9077e91382b..6ddf646cda65 100644
--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -520,7 +520,7 @@ static int ac97_bus_remove(struct device *dev)
 	struct ac97_codec_driver *adrv = to_ac97_driver(dev->driver);
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

