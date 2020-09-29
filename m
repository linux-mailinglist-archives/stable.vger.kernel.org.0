Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D93E27C9C3
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732086AbgI2MNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730113AbgI2Lh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0860123B28;
        Tue, 29 Sep 2020 11:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379239;
        bh=kvljy/+dKd5hVOBCgeK3ADPEBHeF/kDaMYGcYzXQcjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYhhH5E+mnb4pL1c7nyr4/SfdJ6JkleqRC+k6EH0xc9XpxtywUzy1n3N+cKZnRHDq
         LL4ZDG/blqbzgo8Qy/d3e0y2v2+rR9caqgAnHRYyOs9V01OVVqEa4ND12W7Fo3bJ9q
         Rn4NYqga82fSgLkpS+qe4q9hEEYWS3i8oHs4cCNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/388] ALSA: hda: enable regmap internal locking
Date:   Tue, 29 Sep 2020 12:56:45 +0200
Message-Id: <20200929110014.076891142@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 8e85def5723eccea30ebf22645673692ab8cb3e2 ]

This reverts commit 42ec336f1f9d ("ALSA: hda: Disable regmap
internal locking").

Without regmap locking, there is a race between snd_hda_codec_amp_init()
and PM callbacks issuing regcache_sync(). This was caught by
following kernel warning trace:

<4> [358.080081] WARNING: CPU: 2 PID: 4157 at drivers/base/regmap/regcache.c:498 regcache_cache_only+0xf5/0x130
[...]
<4> [358.080148] Call Trace:
<4> [358.080158]  snd_hda_codec_amp_init+0x4e/0x100 [snd_hda_codec]
<4> [358.080169]  snd_hda_codec_amp_init_stereo+0x40/0x80 [snd_hda_codec]

Suggested-by: Takashi Iwai <tiwai@suse.de>
BugLink: https://gitlab.freedesktop.org/drm/intel/issues/592
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200108180856.5194-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_regmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/hda/hdac_regmap.c b/sound/hda/hdac_regmap.c
index 2596a881186fa..49780399c2849 100644
--- a/sound/hda/hdac_regmap.c
+++ b/sound/hda/hdac_regmap.c
@@ -363,7 +363,6 @@ static const struct regmap_config hda_regmap_cfg = {
 	.reg_write = hda_reg_write,
 	.use_single_read = true,
 	.use_single_write = true,
-	.disable_locking = true,
 };
 
 /**
-- 
2.25.1



