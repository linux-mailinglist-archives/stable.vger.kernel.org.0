Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481AB3E818C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhHJSAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236963AbhHJR4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9996137D;
        Tue, 10 Aug 2021 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617501;
        bh=shCdDjnZtYtla1OUNgFX+5xVre4DZppOtg+ux1VdUAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrBHayE1ys4xtv28+QHJ1lGO/D702wH7pj7pV5Hnj1UkUx3yRT0y5HDDjJGdd4nG6
         /ftufBNcyctCz6G9jcMdoiD2XUGglsKpNeeTcIlVxcQam4zcAVu7vWa00xy+cH2lww
         gVDLYy6cpSSn4rSyJTcIfAGNz0F3D0DWbWoXhkPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 086/175] ALSA: usb-audio: Fix superfluous autosuspend recovery
Date:   Tue, 10 Aug 2021 19:29:54 +0200
Message-Id: <20210810173003.775880641@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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


