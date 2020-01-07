Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE2B913349C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgAGU6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgAGU6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35AC0208C4;
        Tue,  7 Jan 2020 20:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430717;
        bh=w7x2HHVjQ86zAJ3fEYgFx+ap+WObzLzXfqLF4nzZdeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcGNlMzS0u8yEpYy6L2hefdMGY2iYSU/FIU4p2DEx5sKi8pNGOjNI5D4LhPeFEFtb
         ixYvHdowjdEnDhvl8e3sG23hqLDw1tzrhIcbV8kh6N5xmmhDsOEjuHK9Qhlue38+kH
         G4boimqms4ZQ7LeH9riEdlJpemUJd/QWmw/g+n58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 067/191] ALSA: usb-audio: fix set_format altsetting sanity check
Date:   Tue,  7 Jan 2020 21:53:07 +0100
Message-Id: <20200107205336.576580613@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 0141254b0a74b37aa7eb13d42a56adba84d51c73 upstream.

Make sure to check the return value of usb_altnum_to_altsetting() to
avoid dereferencing a NULL pointer when the requested alternate settings
is missing.

The format altsetting number may come from a quirk table and there does
not seem to be any other validation of it (the corresponding index is
checked however).

Fixes: b099b9693d23 ("ALSA: usb-audio: Avoid superfluous usb_set_interface() calls")
Cc: stable <stable@vger.kernel.org>     # 4.18
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191220093134.1248-1-johan@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -506,9 +506,9 @@ static int set_format(struct snd_usb_sub
 	if (WARN_ON(!iface))
 		return -EINVAL;
 	alts = usb_altnum_to_altsetting(iface, fmt->altsetting);
-	altsd = get_iface_desc(alts);
-	if (WARN_ON(altsd->bAlternateSetting != fmt->altsetting))
+	if (WARN_ON(!alts))
 		return -EINVAL;
+	altsd = get_iface_desc(alts);
 
 	if (fmt == subs->cur_audiofmt)
 		return 0;


