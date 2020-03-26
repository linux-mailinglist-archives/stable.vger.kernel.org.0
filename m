Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5646E194C60
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgCZXYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgCZXYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16DE32082D;
        Thu, 26 Mar 2020 23:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265075;
        bh=Nk6KRHSuSV+vV3uuL0Fbyt7lBGmFCrHu/aiRdLfbfJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRTZ7lKpu0inxg3I9vc5AjPs6v0vMNMQZ2tadk2DggfIPnRiTLXxkAkZCRspMQvum
         MHn20/pSqbFfq+l7fVMBbsTk+hLOzku7gmaqj26kBSudNiKJ1C2EUMp2SOYzPdH525
         TdNGadjeacKMbboITareCm7yIvzGhxhBFa7zJbZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 03/19] ALSA: hda/realtek: Fix pop noise on ALC225
Date:   Thu, 26 Mar 2020 19:24:15 -0400
Message-Id: <20200326232431.7816-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 3b36b13d5e69d6f51ff1c55d1b404a74646c9757 ]

Commit 317d9313925c ("ALSA: hda/realtek - Set default power save node to
0") makes the ALC225 have pop noise on S3 resume and cold boot.

So partially revert this commit for ALC225 to fix the regression.

Fixes: 317d9313925c ("ALSA: hda/realtek - Set default power save node to 0")
BugLink: https://bugs.launchpad.net/bugs/1866357
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200311061328.17614-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 12858d95c2c85..73b182db7ef3b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8080,6 +8080,8 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->gen.mixer_nid = 0;
 		break;
 	case 0x10ec0225:
+		codec->power_save_node = 1;
+		/* fall through */
 	case 0x10ec0295:
 	case 0x10ec0299:
 		spec->codec_variant = ALC269_TYPE_ALC225;
-- 
2.20.1

