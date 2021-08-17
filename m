Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C913EE137
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhHQAhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236650AbhHQAgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7105F60F5C;
        Tue, 17 Aug 2021 00:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160577;
        bh=fQjiYcuWvLF6FW+Y5XC25D4MUKcLwqTZf9pVCWMyCJ0=;
        h=From:To:Cc:Subject:Date:From;
        b=g4BPdVxOHFqk5SgEGbWA04rp4eLcMIJDfxikORwoRcfERlvWcu8pi+bu7Yr5LcN3a
         gtvE0pykXoupmWYv1QSpnqDeuqZ0LxXg7djKOs1/DYn2WBsKe1A9xJ8EXByzsfRDyO
         eLEdIIQWzDt+dUxGiR702W3XBLnvpUbmZcb1ocNWTiFaXR/01oTW0Gg7xTxPSa40zt
         10Fo16nwknIVq6dSycwANNGnBCy/fkV2s6jpT/6RQe74iNfpbv1/EdL6nzI9xveayh
         jT8z3cxpGIpZ8/fA8J/8rg6hpxA0I2vs4WQbUlWg5m0EkjQOQLDaZo7ENC6MWurEa5
         tD1JfTuSMvDVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 1/4] ASoC: wm_adsp: Let soc_cleanup_component_debugfs remove debugfs
Date:   Mon, 16 Aug 2021 20:36:12 -0400
Message-Id: <20210817003615.83434-1-sashal@kernel.org>
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
index 02c557e1f779..47a4363ebde9 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -651,7 +651,6 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
 static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
 {
 	wm_adsp_debugfs_clear(dsp);
-	debugfs_remove_recursive(dsp->debugfs_root);
 }
 #else
 static inline void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
-- 
2.30.2

