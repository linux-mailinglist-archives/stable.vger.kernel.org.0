Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569F63EE149
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbhHQAim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236098AbhHQAg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E006103A;
        Tue, 17 Aug 2021 00:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160587;
        bh=rjqnYV+POj9OvYKZoXpqHeAKVBzGhPfa+r0LODo5UqA=;
        h=From:To:Cc:Subject:Date:From;
        b=Cwdm4F37E8xkvvPHuK2m4h7+iN0zJQNLPRf5asuUWuZlGyV5ev1AOSV05svcddlsA
         jbk5NC1Ktl9Q/sD09+kqFFKfaW2OA2EM1Lz1iIwv15W1e0+i2ga69ESqhdqXufYx9Z
         Ni6MVokhm/iRFyrFmQ+SEs96d/qKxxxcz3fHmN5jc2pEJGEs6L1DRpVK5sfaVR8wjK
         dfCAXaysNM+2mxxElhf7f+TLR3UP5KRCVQ9g3riK7OsHNIWOcm/Tdxusl47WqGc15c
         tMzvCXPp5glpa+Fuj01axN3tweN6nDGN9i7aFZZZ1r9835K+1+lzOGOLZ1C+KIN3gB
         lwCykmh4eFRaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 1/2] ASoC: wm_adsp: Let soc_cleanup_component_debugfs remove debugfs
Date:   Mon, 16 Aug 2021 20:36:24 -0400
Message-Id: <20210817003625.83589-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 00dd37f10daf..1347131e8b94 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -585,7 +585,6 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
 static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
 {
 	wm_adsp_debugfs_clear(dsp);
-	debugfs_remove_recursive(dsp->debugfs_root);
 }
 #else
 static inline void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
-- 
2.30.2

