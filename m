Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2C19B0F3
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbgDAQak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387517AbgDAQaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:30:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C742137B;
        Wed,  1 Apr 2020 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758639;
        bh=sBYjmDOUDPcyiA4kFehRkIHe+n4K2cjZWYVZxikYKO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+2n3+qXFftEEZuqTuyrZ5sAIsvQ+sGs/6NILSXf1hqJZ/5EFVOm1MvcCkqY8Jgp7
         8pwBwkLhMz8nK7dqqXwwVj1tBhkLQP7McqseaXMu55agI7x1MHc8gduxc3i/ApeaSU
         DekmE4eZ7pRKrDKE7jbxwGsAkXuoGxX64cALHuBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 31/91] ALSA: hda/realtek: Fix pop noise on ALC225
Date:   Wed,  1 Apr 2020 18:17:27 +0200
Message-Id: <20200401161524.427131693@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 3b36b13d5e69d6f51ff1c55d1b404a74646c9757 upstream.

Commit 317d9313925c ("ALSA: hda/realtek - Set default power save node to
0") makes the ALC225 have pop noise on S3 resume and cold boot.

So partially revert this commit for ALC225 to fix the regression.

Fixes: 317d9313925c ("ALSA: hda/realtek - Set default power save node to 0")
BugLink: https://bugs.launchpad.net/bugs/1866357
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200311061328.17614-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6333,6 +6333,8 @@ static int patch_alc269(struct hda_codec
 		alc_update_coef_idx(codec, 0x36, 1 << 13, 1 << 5); /* Switch pcbeep path to Line in path*/
 		break;
 	case 0x10ec0225:
+		codec->power_save_node = 1;
+		/* fall through */
 	case 0x10ec0295:
 	case 0x10ec0299:
 		spec->codec_variant = ALC269_TYPE_ALC225;


