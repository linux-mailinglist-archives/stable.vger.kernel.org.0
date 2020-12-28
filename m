Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7AC2E678B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbgL1NIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730974AbgL1NIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A164206ED;
        Mon, 28 Dec 2020 13:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160883;
        bh=dwqTAokXpysVZGBemVnEBeDmQu20+uI6XLgm1AZ8Yks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jk0GDjHhBcRJyK/eB2pymAQftoFbSJ2U3et4bY372RcAX13JKzrICOeJhEKjU1cxb
         MN3bJuN7jjgth4DTgJSSu/EIQQVkbJmgeHgVlwU5sm9zlDpE13feyaS3ly/DhpAFb/
         rsZlbz6L+5dqaahMaT2kWdcBp0hB3Z8Yqi7Glfkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+df7dc146ebdd6435eea3@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 027/242] ALSA: usb-audio: Fix potential out-of-bounds shift
Date:   Mon, 28 Dec 2020 13:47:12 +0100
Message-Id: <20201228124906.005792110@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 43d5ca88dfcd35e43010fdd818e067aa9a55f5ba upstream.

syzbot spotted a potential out-of-bounds shift in the USB-audio format
parser that receives the arbitrary shift value from the USB
descriptor.

Add a range check for avoiding the undefined behavior.

Reported-by: syzbot+df7dc146ebdd6435eea3@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201209084552.17109-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/format.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -52,6 +52,8 @@ static u64 parse_audio_format_i_type(str
 	case UAC_VERSION_1:
 	default: {
 		struct uac_format_type_i_discrete_descriptor *fmt = _fmt;
+		if (format >= 64)
+			return 0; /* invalid format */
 		sample_width = fmt->bBitResolution;
 		sample_bytes = fmt->bSubframeSize;
 		format = 1 << format;


