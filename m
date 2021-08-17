Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7917E3EE13C
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbhHQAhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236890AbhHQAhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F8FA6102A;
        Tue, 17 Aug 2021 00:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160591;
        bh=jmzD6vyI/X+6zQaDKVv+OPpTfvKGCEmrMkQhgTYSBq4=;
        h=From:To:Cc:Subject:Date:From;
        b=H8IrW44pJ2vuTyF4MbWO+WU81p0paz8tP0mTp4ooQroEIiDP5Jmb46SrOf8Fsri78
         VWjzVSLNVCG0UhGnPMZqsyudOypqXSP/0idusg46U+fH9I03UunWJmA4bkypEasG4U
         pzKB8N4zMe65HBQ87hAYzJ0JGKpHkiG4QIL5cIMBSixbPepHK37tbyKWSva+pYqRBT
         ObEg3eL7dfKRZY8PAsKce3tI7tkjOes39S+xCKP6EckxlOgaJfhd7xbGtJFaAuYk46
         bEEnxjt312VoiibYnyg4DPE35+nRNDLXLOowXM1P6unGSNUPq1ShBBnLRif+30mftY
         fSoMUs++mc6KA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 1/2] ASoC: wm_adsp: Let soc_cleanup_component_debugfs remove debugfs
Date:   Mon, 16 Aug 2021 20:36:28 -0400
Message-Id: <20210817003629.83659-1-sashal@kernel.org>
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
index 5ff0d3b10bcf..ceb1daf99526 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -391,7 +391,6 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
 static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
 {
 	wm_adsp_debugfs_clear(dsp);
-	debugfs_remove_recursive(dsp->debugfs_root);
 }
 #else
 static inline void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
-- 
2.30.2

