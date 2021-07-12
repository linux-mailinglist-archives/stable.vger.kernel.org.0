Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3649B3C473C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhGLGbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234434AbhGLGbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B3A56101E;
        Mon, 12 Jul 2021 06:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071307;
        bh=XKQ7PddeWqOUTtxv6hvVS3NyeUSWTYVdVkn/LXHTfLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXV5TVvsUwGQlLme7MsqWxiKCWD7DjRcHF/GUTe0fxgNYnuaqLQ60oGyh1XsfrGSu
         flqY929CQlHzyaw2eIAyqo71BimPAnQOQ5/Xy0ZQmGUSW4iumZjoMGZ9Vnu2PCfSfm
         H3EE2vAh+D3rj3lEotUPOVJyyTGuRyntc7++s7Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 015/593] ALSA: hda/realtek: Fix bass speaker DAC mapping for Asus UM431D
Date:   Mon, 12 Jul 2021 08:02:55 +0200
Message-Id: <20210712060844.860662221@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit f8fbcdfb0665de60997d9746809e1704ed782bbc upstream.

Asus Zenbook 14 UM431D has two speaker pins and a headphone pin, and
the auto-parser ends up assigning the bass to the third DAC 0x06.
Although the tone comes out, it's inconvenient because this DAC has no
volume control unlike two other DACs.

For obtaining the volume control for the bass speaker, this patch
enforces the mapping to let both front and bass speaker pins sharing
the same DAC.  It's not ideal but a little bit of improvement.

Since we've already applied the same workaround for another ASUS
machine, we just need to hook the chain to the existing quirk.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212547
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210620065952.18948-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7831,6 +7831,8 @@ static const struct hda_fixup alc269_fix
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x4e4b },
 			{ }
 		},
+		.chained = true,
+		.chain_id = ALC289_FIXUP_ASUS_GA401,
 	},
 	[ALC285_FIXUP_HP_GPIO_LED] = {
 		.type = HDA_FIXUP_FUNC,


