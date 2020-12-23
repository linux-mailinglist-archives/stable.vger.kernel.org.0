Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA042E13E9
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgLWCgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730238AbgLWCYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D6223137;
        Wed, 23 Dec 2020 02:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690254;
        bh=+wJUFYaFYeKD3BKxzQ9mNJZkS6nkCiu7oo1clnzeQVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiW4HIQIMmJhX6mPh5LsDTL9N5/+zGRxMiJM2Xd76AQNGGs1baQgcFBdV7rKfDK9E
         MH0LFAmfMrWSIv3mbE3IJwvNDlcLa9nqtUrBAJCXJCpCr+ZNE9Ii/AUq4M0IyACZk6
         76phY020Z87F0kuN5Iry8+6t45UjGgJRPmxbIDvqz0NhU00hLAATF+RVAvC3ff1efu
         asjGJC2TbpsTrdjQyaQ7JREXqOMat1jBE/mxUnVvO0s0P0ZJxz+e0WPaafBr/a+Sy+
         /J7antnXyD3EONcOggZaP/h7ody3ThCnNH7hbdkXgwSriem4fkfjJep0Mb2yX7RIqd
         bmKdsinGiszuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 65/66] ALSA: hda/hdmi: packet buffer index must be set before reading value
Date:   Tue, 22 Dec 2020 21:22:51 -0500
Message-Id: <20201223022253.2793452-65-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 46c3bbd9827952f92e250fa6ee30a797a4c4e17e ]

The check for infoframe transmit status in hdmi_infoframe_uptodate()
makes the assumption that packet buffer index is set to zero.

Align code with specification and explicitly set the index before
AC_VERB_GET_HDMI_DIP_XMIT. The packet index setting affects both
DIP-Data and DIP-XmitCtrl verbs.

There are no known cases where the old implementation has caused driver
to work incorrectly. This change is purely based on code review against
the specification (HDA spec rev1.0a).

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20201211131613.3271407-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 21d9b7d96eb0f..35da926507ac3 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -642,11 +642,11 @@ static bool hdmi_infoframe_uptodate(struct hda_codec *codec, hda_nid_t pin_nid,
 	u8 val;
 	int i;
 
+	hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
 	if (snd_hda_codec_read(codec, pin_nid, 0, AC_VERB_GET_HDMI_DIP_XMIT, 0)
 							    != AC_DIPXMIT_BEST)
 		return false;
 
-	hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
 	for (i = 0; i < size; i++) {
 		val = snd_hda_codec_read(codec, pin_nid, 0,
 					 AC_VERB_GET_HDMI_DIP_DATA, 0);
-- 
2.27.0

