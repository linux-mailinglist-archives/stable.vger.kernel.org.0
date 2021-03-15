Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6583A33B979
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhCOOGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233369AbhCOOBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C861E64FB2;
        Mon, 15 Mar 2021 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816865;
        bh=T8Z3ON9Dfnl14NHHXv96sr73TwTKtyfJMyfBAYYkE7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9HqpNBJVkmvo7nVe3eZgpqH2kEgYjANwqfbQibsmaMtecshceSKp2XmKHDOTuXJX
         7SuI9YpimP8w6XCu3RLL2cJTw6kbvTxACBz+vIaSBisLEHLHofrU5IaJqaD0NwkahB
         +yriYoqx1r9WP1Kr7E8zGLLaC8lNG/hTK5prHUY0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 171/306] ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar
Date:   Mon, 15 Mar 2021 14:53:54 +0100
Message-Id: <20210315135513.399886052@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit fec60c3bc5d1713db2727cdffc638d48f9c07dc3 upstream.

Dell AE515 sound bar (413c:a506) spews the error messages when the
driver tries to read the current sample frequency, hence it needs to
be on the list in snd_usb_get_sample_rate_quirk().

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211551
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210304083021.2152-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1520,6 +1520,7 @@ bool snd_usb_get_sample_rate_quirk(struc
 	case USB_ID(0x1901, 0x0191): /* GE B850V3 CP2114 audio interface */
 	case USB_ID(0x21b4, 0x0081): /* AudioQuest DragonFly */
 	case USB_ID(0x2912, 0x30c8): /* Audioengine D1 */
+	case USB_ID(0x413c, 0xa506): /* Dell AE515 sound bar */
 		return true;
 	}
 


