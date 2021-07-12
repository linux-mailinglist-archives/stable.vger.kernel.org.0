Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35D13C44B9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhGLGVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhGLGUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FF2610E6;
        Mon, 12 Jul 2021 06:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070648;
        bh=pUMr10Mt4SCKAEeSUQG9mur+NfbW4jFFoQ3QkBymMrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCBUXm4zAPOT7mN1m3gM4vjIAeIeSWnRcXQIPwJstzkwrbKsfnhUHTw5sTe7BxP1Z
         kTj6k9/JSkD/AQFer5El5cEZ69sVzrvYng7tq0Apzp0u2VBa8NrA1iSdj0eNUhHZdd
         FQF7qa2o/usmrCjI4AKRrn8oT4O/qs003vYlOm1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e74a998ca8f1df9cc332@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/348] media: pvrusb2: fix warning in pvr2_i2c_core_done
Date:   Mon, 12 Jul 2021 08:07:45 +0200
Message-Id: <20210712060712.583849935@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit f8194e5e63fdcb349e8da9eef9e574d5b1d687cb ]

syzbot has reported the following warning in pvr2_i2c_done:

	sysfs group 'power' not found for kobject '1-0043'

When the device is disconnected (pvr_hdw_disconnect), the i2c adapter is
not unregistered along with the USB and v4l2 teardown. As part of the USB
device disconnect, the sysfs files of the subdevices are also deleted.
So, by the time pvr_i2c_core_done is called by pvr_context_destroy, the
sysfs files have been deleted.

To fix this, unregister the i2c adapter too in pvr_hdw_disconnect. Make
the device deregistration code shared by calling pvr_hdw_disconnect from
pvr2_hdw_destroy.

Reported-by: syzbot+e74a998ca8f1df9cc332@syzkaller.appspotmail.com
Tested-by: syzbot+e74a998ca8f1df9cc332@syzkaller.appspotmail.com
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 1cfb7cf64131..4c991eae53cd 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2677,9 +2677,8 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
 		pvr2_stream_destroy(hdw->vid_stream);
 		hdw->vid_stream = NULL;
 	}
-	pvr2_i2c_core_done(hdw);
 	v4l2_device_unregister(&hdw->v4l2_dev);
-	pvr2_hdw_remove_usb_stuff(hdw);
+	pvr2_hdw_disconnect(hdw);
 	mutex_lock(&pvr2_unit_mtx);
 	do {
 		if ((hdw->unit_number >= 0) &&
@@ -2706,6 +2705,7 @@ void pvr2_hdw_disconnect(struct pvr2_hdw *hdw)
 {
 	pvr2_trace(PVR2_TRACE_INIT,"pvr2_hdw_disconnect(hdw=%p)",hdw);
 	LOCK_TAKE(hdw->big_lock);
+	pvr2_i2c_core_done(hdw);
 	LOCK_TAKE(hdw->ctl_lock);
 	pvr2_hdw_remove_usb_stuff(hdw);
 	LOCK_GIVE(hdw->ctl_lock);
-- 
2.30.2



