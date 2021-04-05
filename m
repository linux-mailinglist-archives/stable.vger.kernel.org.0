Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CB2353EDD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhDEJIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238475AbhDEJIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C551613AE;
        Mon,  5 Apr 2021 09:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613693;
        bh=bS9v8Sn+M9PdSho+hk1fWodUee1upM8TnfkiJCOAKg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6NZtLtWqjBwD1vnt8wif2jiykt/r+eE8rxCDKByvyG2L0aTsRAm4pJPbRX9nixNv
         qeNc/Ti2Nffp1yHivBH0JbrIVM21tU1MJZZJzoqXzQ/nIUtl4OyJz0+LMlBFfoGQcu
         C74jN0/sb6SZC1s4HIjRAh5Ss6Brfa02S+AVUvFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ikjoon Jang <ikjn@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 057/126] ALSA: usb-audio: Apply sample rate quirk to Logitech Connect
Date:   Mon,  5 Apr 2021 10:53:39 +0200
Message-Id: <20210405085032.937078852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ikjoon Jang <ikjn@chromium.org>

commit 625bd5a616ceda4840cd28f82e957c8ced394b6a upstream.

Logitech ConferenceCam Connect is a compound USB device with UVC and
UAC. Not 100% reproducible but sometimes it keeps responding STALL to
every control transfer once it receives get_freq request.

This patch adds 046d:0x084c to a snd_usb_get_sample_rate_quirk list.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203419
Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210324105153.2322881-1-ikjn@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1521,6 +1521,7 @@ bool snd_usb_get_sample_rate_quirk(struc
 	case USB_ID(0x21b4, 0x0081): /* AudioQuest DragonFly */
 	case USB_ID(0x2912, 0x30c8): /* Audioengine D1 */
 	case USB_ID(0x413c, 0xa506): /* Dell AE515 sound bar */
+	case USB_ID(0x046d, 0x084c): /* Logitech ConferenceCam Connect */
 		return true;
 	}
 


