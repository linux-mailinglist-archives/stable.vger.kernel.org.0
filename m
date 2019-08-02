Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD7E7F38C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406720AbfHBJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407034AbfHBJ6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:58:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD7320B7C;
        Fri,  2 Aug 2019 09:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739883;
        bh=B9V9oPsQD8P75d8VDLpXDxfezBuysYWjwCh63KCoJv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1dswroc+hqrK7Coj5reubWANrXquOKB93FQECzbRux1fZyqOjIiXFayaRMPlArM0
         MV+tYb86GKl7lf2lYCBlQDWL5UAkTOpGHlqleFi3QEj2MySSm5W9DqBG65OKUmxDSs
         KvShD1eGMrZXEOMzcVOwk9ygM7rwjb4SpHbde5OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af8f8d2ac0d39b0ed3a0@syzkaller.appspotmail.com,
        syzbot+170a86bf206dd2c6217e@syzkaller.appspotmail.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.2 08/20] media: pvrusb2: use a different format for warnings
Date:   Fri,  2 Aug 2019 11:40:02 +0200
Message-Id: <20190802092059.716217512@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
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
@@ -1670,7 +1670,7 @@ static int pvr2_decoder_enable(struct pv
 	}
 	if (!hdw->flag_decoder_missed) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "WARNING: No decoder present");
+			   "***WARNING*** No decoder present");
 		hdw->flag_decoder_missed = !0;
 		trace_stbit("flag_decoder_missed",
 			    hdw->flag_decoder_missed);
@@ -2356,7 +2356,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct
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
@@ -333,11 +333,11 @@ static int i2c_hack_cx25840(struct pvr2_
 
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
@@ -343,7 +343,7 @@ struct v4l2_standard *pvr2_std_create_en
 		bcnt = pvr2_std_id_to_str(buf,sizeof(buf),fmsk);
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
-			"WARNING: Failed to classify the following standard(s): %.*s",
+			"***WARNING*** Failed to classify the following standard(s): %.*s",
 			bcnt,buf);
 	}
 


