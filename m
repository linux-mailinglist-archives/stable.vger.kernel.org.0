Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3333B7BF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhCOOBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232747AbhCON7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7164764F67;
        Mon, 15 Mar 2021 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816762;
        bh=f0RumDQbUyftW0X7m32zmBMDsyrOdcMRyHWj8KYVyXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvQ9m7HWS19YU8a6nW2B2Xe1G37McFnjlvyeTOExCqEk5sEIN1nLncJR+xjvBCo8c
         TO+cejVXncLZvFRj1XFwt6kIGpcPHCEJ3ilKGz2HejxJIGOi3DSNM1gn0crk4j9xJj
         w5cbos+r1W8gVgwcU+QdwPGbHyi0KA5tFOBOGhMg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 44/95] ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar
Date:   Mon, 15 Mar 2021 14:57:14 +0100
Message-Id: <20210315135741.715937307@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
@@ -1155,6 +1155,7 @@ bool snd_usb_get_sample_rate_quirk(struc
 	case USB_ID(0x1de7, 0x0114): /* Phoenix Audio MT202pcs */
 	case USB_ID(0x21B4, 0x0081): /* AudioQuest DragonFly */
 	case USB_ID(0x2912, 0x30c8): /* Audioengine D1 */
+	case USB_ID(0x413c, 0xa506): /* Dell AE515 sound bar */
 		return true;
 	}
 	return false;


