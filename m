Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D993EE124
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhHQAg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236195AbhHQAgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A1960EBD;
        Tue, 17 Aug 2021 00:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160559;
        bh=vtINDJhnYlJbTwKRcDq6V78h1LvBAO6MvAcQ0pJthX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaL+TmvoEDWtPvrfxCxb/kvpUwZINHmW9E7B658jsEdVups6nNITnZZVY6ErAfXb5
         uxyI+mtRP4Y8JoC8kT7ybO1xBMeN/BVgfHECFZV7YVox3u7ccEMbsKIM1hLuWx0INR
         53XbPa1tYcCA7uC5hNnLuLKgAC075PDua1hbihLIZYYqLWXJkKPhlCAd9iliaH8zCX
         a5zJYTYyoIirULWQoiBeoVmOP6MIRKepHLv/26NEx42/Ya5ynexeb5YqjAqqn6jANU
         7Vyo/UgcwNV9AscnH8446Lr3Dq5v6X7OEInpTZyHgvNYdHYMk0k4njsP8hQRUnxDYy
         N+5+9L8IlSptg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 3/9] ASoC: wm_adsp: Let soc_cleanup_component_debugfs remove debugfs
Date:   Mon, 16 Aug 2021 20:35:48 -0400
Message-Id: <20210817003554.83213-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003554.83213-1-sashal@kernel.org>
References: <20210817003554.83213-1-sashal@kernel.org>
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
index 51d95437e0fd..ac3c612ad2f1 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -754,7 +754,6 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
 static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
 {
 	wm_adsp_debugfs_clear(dsp);
-	debugfs_remove_recursive(dsp->debugfs_root);
 }
 #else
 static inline void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
-- 
2.30.2

