Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05B120662A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbgFWViT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387945AbgFWUIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34D82080C;
        Tue, 23 Jun 2020 20:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942900;
        bh=SYI8L8UXp3utrE/Mql5+0mceAEsW4wnfH/JOJyjihK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCW2K1sDue8jFIx82KlaNWWhRTlgA2gIV8hZ+6HiqmkiUMlVZVb1EU6aRMtfaZONn
         O61Y79kPLwJiXmvkaHbcz9ZUmAj/2RNShRZH5WCOemY2oBjFfDnGley/OwZ2LDyG3u
         6WOXkDWqlmk2eK+iwOxlmZTS0d5kJsio8XD0fYh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 180/477] ASoC: SOF: core: fix error return code in sof_probe_continue()
Date:   Tue, 23 Jun 2020 21:52:57 +0200
Message-Id: <20200623195416.092361693@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 7d8785bc7adbb4dc5ba8ee06994107637848ded8 ]

Fix to return negative error code -ENOMEM from the IPC init error
handling case instead of 0, as done elsewhere in this function.

Fixes: c16211d6226d ("ASoC: SOF: Add Sound Open Firmware driver core")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20200509093337.78897-1-weiyongjun1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 91acfae7935c9..74b4382162167 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -176,6 +176,7 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	/* init the IPC */
 	sdev->ipc = snd_sof_ipc_init(sdev);
 	if (!sdev->ipc) {
+		ret = -ENOMEM;
 		dev_err(sdev->dev, "error: failed to init DSP IPC %d\n", ret);
 		goto ipc_err;
 	}
-- 
2.25.1



