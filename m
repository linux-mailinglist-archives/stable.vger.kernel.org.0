Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2635C3E801B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhHJRqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233895AbhHJRnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C30260F11;
        Tue, 10 Aug 2021 17:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617139;
        bh=shCdDjnZtYtla1OUNgFX+5xVre4DZppOtg+ux1VdUAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHiGav7+enZaXXkOcl7pcM2xKMI1CVBJOawG6Vfe+y9HjjBuRgVWmgnSkJNDlGORb
         UMtX+3nOW/JtlsYasZZCxpsDE0svcB3F6AZeT/yKlULY1f2JjuywLUA3aV/NzDqURp
         qvrirTZ71XD8gv5zO6Jyi92+cwS6w5g73ux5vLy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 062/135] ALSA: usb-audio: Fix superfluous autosuspend recovery
Date:   Tue, 10 Aug 2021 19:29:56 +0200
Message-Id: <20210810172957.798353741@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 66291b6adb66dd3bc96b0f594d88c2ff1300d95f upstream.

The change to restore the autosuspend from the disabled state uses a
wrong check: namely, it should have been the exact comparison of the
quirk_type instead of the bitwise and (&).  Otherwise it matches
wrongly with the other quirk types.

Although re-enabling the autosuspend for the already enabled device
shouldn't matter much, it's better to fix the unbalanced call.

Fixes: 9799110825db ("ALSA: usb-audio: Disable USB autosuspend properly in setup_disable_autosuspend()")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/s5hr1flh9ov.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -907,7 +907,7 @@ static void usb_audio_disconnect(struct
 		}
 	}
 
-	if (chip->quirk_type & QUIRK_SETUP_DISABLE_AUTOSUSPEND)
+	if (chip->quirk_type == QUIRK_SETUP_DISABLE_AUTOSUSPEND)
 		usb_enable_autosuspend(interface_to_usbdev(intf));
 
 	chip->num_interfaces--;


