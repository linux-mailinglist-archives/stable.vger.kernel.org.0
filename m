Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146861D8610
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbgERRuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbgERRtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:49:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAD920674;
        Mon, 18 May 2020 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824195;
        bh=kszVDRYCIaCRP68xZeHGWaRaIxu6FkskzVt1W9UP1Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgUIhAJiPVBe6rZSIVvdIKwmunS922jYw88hpSNdjUNvS3bACLxmwwvNEoH5WxmxX
         O6I/dGK82rqms62S+JU7joyxHeS1xF68MEBMW7TEDf7jV5Of+bLsG/bFswqZKqFN7a
         WaWzkqMXIo+kfv3Mnhu34Snf1BY5YLYknK8aXxTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 108/114] Revert "ALSA: hda/realtek: Fix pop noise on ALC225"
Date:   Mon, 18 May 2020 19:37:20 +0200
Message-Id: <20200518173520.604737985@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit f41224efcf8aafe80ea47ac870c5e32f3209ffc8 upstream.

This reverts commit 3b36b13d5e69d6f51ff1c55d1b404a74646c9757.

Enable power save node breaks some systems with ACL225. Revert the patch
and use a platform specific quirk for the original issue isntead.

Fixes: 3b36b13d5e69 ("ALSA: hda/realtek: Fix pop noise on ALC225")
BugLink: https://bugs.launchpad.net/bugs/1875916
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200503152449.22761-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4691,8 +4691,6 @@ static void alc_determine_headset_type(s
 		is_ctia = (val & 0x1c02) == 0x1c02;
 		break;
 	case 0x10ec0225:
-		codec->power_save_node = 1;
-		/* fall through */
 	case 0x10ec0295:
 	case 0x10ec0299:
 		alc_process_coef_fw(codec, alc225_pre_hsmode);


