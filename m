Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1FA38E974
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhEXOtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233344AbhEXOs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:48:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6525613CC;
        Mon, 24 May 2021 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867621;
        bh=w6PHIeP+6wvAl57XhxGtKV/10eR+mrKICHgDdT2CgXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgQAbjWYPlL1i1YObImOBY9ERf2wHlhAUhcwHmMWgTa2Gf6KJIxFwbySMYIr5T49o
         xSN3VAO0IhKBbRVimJum05/AaAKUf6Ptja+PAW9YPJEvGo76ljj2f/q7wTJNQWMtk6
         Ccgnz0OTvBwGS7Daw1f1D16OMGF1Fv02Pm2Xso6qVPG/qz4WqmasoijlnXB1TxYo2N
         CkS8mhu7gcicFZkwT/BYQF5+78pcuzc2CiwnmlTeo4XlW7b0BVTUy1FwxUsRxKdVrW
         0Jew7Wr4NvTavmCDquQ7fIEwi0f6cLqlbfFPb6P0pKkdjYaTljHTi8Fj+vD1XXFHW0
         BWHtlnLLtYb3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.12 31/63] Revert "ASoC: cs43130: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:45:48 -0400
Message-Id: <20210524144620.2497249-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 80bc7c10ed75..c2b6f0ae6d57 100644
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

