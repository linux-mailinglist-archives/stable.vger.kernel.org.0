Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C693BB1E2
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhGDXN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232082AbhGDXMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:12:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF598613F3;
        Sun,  4 Jul 2021 23:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440121;
        bh=UP4NVnaV6TahKYzkSvQfpMg9+VdQvMocKGAKxZKRlTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcqO4i8nXBb9JE8qP1sascNG2fw7gQqsGBDxbc1L5r65BZMPoZJEN7R69hAiALvdF
         utN9N/bbYF6QD0Lsv7byGyt5eUO+f5F99smfZ+THtbmlyA1dfjomzpgqNQ63CB8Tmo
         52AL997LXRXScCzkmeYHpmCCnAsQbwmwNRpKV7vhN/TW241Q+SS/cg0cOZHGQnN0P/
         1Gh9n7bZqk++3tvwbl1Bt+TsunIAnEQjRCu7AXr0OICCUiRRd1jAtsaRxIv+TB/Bad
         1QOBFB4vM4t4i5N3RldjGpYuc5aGkuupc4JPvbtcc+rXn+5/AwwXj7riUHzOprUW9h
         d9AZpeyLqDF9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+e74a998ca8f1df9cc332@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/70] media: pvrusb2: fix warning in pvr2_i2c_core_done
Date:   Sun,  4 Jul 2021 19:07:20 -0400
Message-Id: <20210704230804.1490078-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f4a727918e35..d38dee1792e4 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2676,9 +2676,8 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
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
@@ -2705,6 +2704,7 @@ void pvr2_hdw_disconnect(struct pvr2_hdw *hdw)
 {
 	pvr2_trace(PVR2_TRACE_INIT,"pvr2_hdw_disconnect(hdw=%p)",hdw);
 	LOCK_TAKE(hdw->big_lock);
+	pvr2_i2c_core_done(hdw);
 	LOCK_TAKE(hdw->ctl_lock);
 	pvr2_hdw_remove_usb_stuff(hdw);
 	LOCK_GIVE(hdw->ctl_lock);
-- 
2.30.2

