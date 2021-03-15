Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8533B997
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhCOOGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233471AbhCOOBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 726B764F1A;
        Mon, 15 Mar 2021 14:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816901;
        bh=T8Z3ON9Dfnl14NHHXv96sr73TwTKtyfJMyfBAYYkE7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEcgEEm4llT1/bSnkbuc5NbCuPxSwU1vODHtBLr8/TuM0cmCy68uPK1Bny0gT/tRT
         EScyVEzPf88NV4zzM31t/hsPpZGkf+r0V2e8FsP4Vh1YGjB/ax4d4JKPOMiijwfIZr
         WyP1XQw/LXLge3mLz/AqSFhqBhNi4f57ERrz+uN4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 178/290] ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar
Date:   Mon, 15 Mar 2021 14:54:31 +0100
Message-Id: <20210315135547.927242069@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
 


