Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E303C3EE103
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhHQAgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235367AbhHQAgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73C9B60FC3;
        Tue, 17 Aug 2021 00:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160541;
        bh=Aqqg/+LAdGFrSRrekR1o1Bc4hvcDvgmePZggkIIT3UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9Y2J/A4lHWN/fY7RA9YiZrosX7Hc/solfTM4YpPtzv556s5LzwWHd++nlH0FoQ8C
         6W656iv7ivppiK+4vEX9JKvrWn38K1nX/1uvXpdXnAkkhHyr+7xhz/oiK6EesDJlYl
         i1MS+XN7ozcuIjdk2fB/HSCMxTeiiCLXgvdq0ekRveseCllqDxI+9ktTG9gm6FRe42
         REkjrVEimnUnHw0mpnwbCuhQRnQWyfXlC8UgCTSAIsRgcKzVMMNOSd0pwDYoF/v155
         EJ6IQRcWUMDpsA3m/57I89zyO9Rd2v3wk2jOup9G5L6fcW2g7JCjFYoD+dR5EwPT/x
         aa9B6YRJU/rlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 03/12] ASoC: wm_adsp: Let soc_cleanup_component_debugfs remove debugfs
Date:   Mon, 16 Aug 2021 20:35:27 -0400
Message-Id: <20210817003536.83063-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003536.83063-1-sashal@kernel.org>
References: <20210817003536.83063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit acbf58e530416e167c3b323111f4013d9f2b0a7d ]

soc_cleanup_component_debugfs will debugfs_remove_recursive
the component->debugfs_root, so adsp doesn't need to also
remove the same entry.
By doing that adsp also creates a race with core component,
which causes a NULL pointer dereference

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210728104416.636591-1-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index cef05d81c39b..6698b5343974 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -746,7 +746,6 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
 static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
 {
 	wm_adsp_debugfs_clear(dsp);
-	debugfs_remove_recursive(dsp->debugfs_root);
 }
 #else
 static inline void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
-- 
2.30.2

