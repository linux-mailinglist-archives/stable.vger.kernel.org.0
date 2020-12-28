Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B2D2E6967
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgL1Mwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgL1Mwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:52:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC6C8224D2;
        Mon, 28 Dec 2020 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159902;
        bh=dwqTAokXpysVZGBemVnEBeDmQu20+uI6XLgm1AZ8Yks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1TigjctYOKNG9BdrwfpsXMLsFxzuzzb1Hchew+S9Ui5p0hK/Y24TsqiyczPHugnb
         VhCmAaN3lCNGcoDp0AasMf84RyxXyznVcO6x91m6ChlglCEJYXO6LDuyg7WpaS9bR8
         zXxFc3QGdowJUuW49qsDqqM0LvOQ5SiWBh5Iq/8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+df7dc146ebdd6435eea3@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 015/132] ALSA: usb-audio: Fix potential out-of-bounds shift
Date:   Mon, 28 Dec 2020 13:48:19 +0100
Message-Id: <20201228124847.139402278@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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


