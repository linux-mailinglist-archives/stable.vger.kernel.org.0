Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEFD7F325
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406370AbfHBJyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406361AbfHBJyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:54:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 473502087E;
        Fri,  2 Aug 2019 09:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739642;
        bh=2M4LsMCYSTJ+DLyD6bGxETD1IqcGUbcDFi3bO237WuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKP5RaQ5BybSnUvHObz4XZzFoH1mW1xk3Ecoqk2nVQBvgwdGKpGSeHz/wPwGDvSHF
         vNekRoZyE0NOENPPqW+CLLDu8WsZv5vAqSUG+gHUD74SdBru5flXzLgYXnMZRrcnPe
         3t24vhamWL0YonaHH8HjweQHVCbQla6bhp3X907E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af8f8d2ac0d39b0ed3a0@syzkaller.appspotmail.com,
        syzbot+170a86bf206dd2c6217e@syzkaller.appspotmail.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.14 14/25] media: pvrusb2: use a different format for warnings
Date:   Fri,  2 Aug 2019 11:39:46 +0200
Message-Id: <20190802092103.999190221@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit 1753c7c4367aa1201e1e5d0a601897ab33444af1 upstream.

When the pvrusb2 driver detects that there's something wrong with the
device, it prints a warning message. Right now those message are
printed in two different formats:

1. ***WARNING*** message here
2. WARNING: message here

There's an issue with the second format. Syzkaller recognizes it as a
message produced by a WARN_ON(), which is used to indicate a bug in the
kernel. However pvrusb2 prints those warnings to indicate an issue with
the device, not the bug in the kernel.

This patch changes the pvrusb2 driver to consistently use the first
warning message format. This will unblock syzkaller testing of this
driver.

Reported-by: syzbot+af8f8d2ac0d39b0ed3a0@syzkaller.appspotmail.com
Reported-by: syzbot+170a86bf206dd2c6217e@syzkaller.appspotmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |    4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    6 +++---
 drivers/media/usb/pvrusb2/pvrusb2-std.c      |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -1680,7 +1680,7 @@ static int pvr2_decoder_enable(struct pv
 	}
 	if (!hdw->flag_decoder_missed) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "WARNING: No decoder present");
+			   "***WARNING*** No decoder present");
 		hdw->flag_decoder_missed = !0;
 		trace_stbit("flag_decoder_missed",
 			    hdw->flag_decoder_missed);
@@ -2365,7 +2365,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct
 	if (hdw_desc->flag_is_experimental) {
 		pvr2_trace(PVR2_TRACE_INFO, "**********");
 		pvr2_trace(PVR2_TRACE_INFO,
-			   "WARNING: Support for this device (%s) is experimental.",
+			   "***WARNING*** Support for this device (%s) is experimental.",
 							      hdw_desc->description);
 		pvr2_trace(PVR2_TRACE_INFO,
 			   "Important functionality might not be entirely working.");
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -343,11 +343,11 @@ static int i2c_hack_cx25840(struct pvr2_
 
 	if ((ret != 0) || (*rdata == 0x04) || (*rdata == 0x0a)) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "WARNING: Detected a wedged cx25840 chip; the device will not work.");
+			   "***WARNING*** Detected a wedged cx25840 chip; the device will not work.");
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "WARNING: Try power cycling the pvrusb2 device.");
+			   "***WARNING*** Try power cycling the pvrusb2 device.");
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "WARNING: Disabling further access to the device to prevent other foul-ups.");
+			   "***WARNING*** Disabling further access to the device to prevent other foul-ups.");
 		// This blocks all further communication with the part.
 		hdw->i2c_func[0x44] = NULL;
 		pvr2_hdw_render_useless(hdw);
--- a/drivers/media/usb/pvrusb2/pvrusb2-std.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-std.c
@@ -353,7 +353,7 @@ struct v4l2_standard *pvr2_std_create_en
 		bcnt = pvr2_std_id_to_str(buf,sizeof(buf),fmsk);
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"WARNING: Failed to classify the following standard(s): %.*s",
+			"***WARNING*** Failed to classify the following standard(s): %.*s",
 			bcnt,buf);
 	}
 


