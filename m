Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A498C38EA6C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhEXOzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhEXOxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:53:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0425761423;
        Mon, 24 May 2021 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867702;
        bh=RQhlUaPK0txnvTpB8EbPl0THdMYPjTwx7mfDkn3q924=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8tdFiIWb8BrBN7FGFMI9gYUZopi/RcSMyF0lFti6LkfnndPr+OmojM607avJM/2+
         4SuPNtxsuzRP58iFGNqR/oZtADfGeVpJXe3U5Bn672sA+68Ey9lgiCZyDBaENQBLo/
         wH4RgSVwG19ya0LMbqGs5riYohtvyQd9QgC5aEsDyIuJAp1db3lWfU/TjQgYXSlYxF
         H6BpJMdlsj+mjY3x1fSsbB7TkMxENy6BGe7ZmJFHDxwidr7HOWTASNp33XbmkubAny
         Tmw0wakVbAWkkPchPV60aeYzfMBcOm1065Y549zT9yxKFz4to8FgzxI08+vKb+/nJh
         4PhjKwAgKLY/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.10 31/62] Revert "ASoC: cs43130: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:47:12 -0400
Message-Id: <20210524144744.2497894-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit fdda0dd2686ecd1f2e616c9e0366ea71b40c485d ]

This reverts commit a2be42f18d409213bb7e7a736e3ef6ba005115bb.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original patch here is not correct, sysfs files that were created
are not unwound.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-57-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
index 7fb34422a2a4..bb46e993c353 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -2319,8 +2319,6 @@ static int cs43130_probe(struct snd_soc_component *component)
 			return ret;
 
 		cs43130->wq = create_singlethread_workqueue("cs43130_hp");
-		if (!cs43130->wq)
-			return -ENOMEM;
 		INIT_WORK(&cs43130->work, cs43130_imp_meas);
 	}
 
-- 
2.30.2

