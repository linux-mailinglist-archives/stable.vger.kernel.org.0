Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF21B44549E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhKDOQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231365AbhKDOQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B46160F39;
        Thu,  4 Nov 2021 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035230;
        bh=aIdRTFWPkEXAjV9AmwU5Qa4tC5Ylagy1T1VHvxzCOfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IPFQVEkRLl8qtxOVELnJXzA8cPTSyUGveFggORG3iEkfnIjyg4UlUOMmqKzJ1V3O
         b6rcOrktOE0YRgiHCUxDZv8+gkX/FSxpp+CywzHwkaemsJ+5VCPIDxc5dEMOyvhsS+
         eRihuHS9C/1J32X583L3xvE8QV8y7xfPKPypBPbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 12/12] ALSA: usb-audio: Add quirk for Audient iD14
Date:   Thu,  4 Nov 2021 15:12:38 +0100
Message-Id: <20211104141159.954361842@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit df0380b9539b04c1ae8854a984098da06d5f1e67 upstream.

Audient iD14 (2708:0002) may get a control message error that
interferes the operation e.g. with alsactl.  Add the quirk to ignore
such errors like other devices.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1191247
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211102161859.19301-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1887,6 +1887,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x21b4, 0x0081, /* AudioQuest DragonFly */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
+		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */


