Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A715119869
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLJVjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbfLJVfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2630F207FF;
        Tue, 10 Dec 2019 21:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013699;
        bh=1babmQM4+K24X+5mb2qf7Srsl8X3oOursEsQlBCqiuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEoVc1hi+TyaFdTiynZr8IDWJRXdYmNmTNrOkpUADhEsyj4TaWaWh1s9usL8r/Byk
         pItubQs1Qvb3u2mnGxEsahSE33VmMsGtFHGDuQ3n0VvKUowM3vZb5ra7ab85OHp96a
         O4Kh6W8wvwWUGCAc2Mv7uK4RIJzY83iZD/rVaJuU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Isely <isely@pobox.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 129/177] media: pvrusb2: Fix oops on tear-down when radio support is not present
Date:   Tue, 10 Dec 2019 16:31:33 -0500
Message-Id: <20191210213221.11921-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Isely <isely@pobox.com>

[ Upstream commit 7f404ae9cf2a285f73b3c18ab9303d54b7a3d8e1 ]

In some device configurations there's no radio or radio support in the
driver.  That's OK, as the driver sets itself up accordingly.  However
on tear-down in these caes it's still trying to tear down radio
related context when there isn't anything there, leading to
dereferences through a null pointer and chaos follows.

How this bug survived unfixed for 11 years in the pvrusb2 driver is a
mystery to me.

[hverkuil: fix two checkpatch warnings]

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index e53a80b589a15..04d334152eae2 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -916,8 +916,12 @@ static void pvr2_v4l2_internal_check(struct pvr2_channel *chp)
 	pvr2_v4l2_dev_disassociate_parent(vp->dev_video);
 	pvr2_v4l2_dev_disassociate_parent(vp->dev_radio);
 	if (!list_empty(&vp->dev_video->devbase.fh_list) ||
-	    !list_empty(&vp->dev_radio->devbase.fh_list))
+	    (vp->dev_radio &&
+	     !list_empty(&vp->dev_radio->devbase.fh_list))) {
+		pvr2_trace(PVR2_TRACE_STRUCT,
+			   "pvr2_v4l2 internal_check exit-empty id=%p", vp);
 		return;
+	}
 	pvr2_v4l2_destroy_no_lock(vp);
 }
 
@@ -953,7 +957,8 @@ static int pvr2_v4l2_release(struct file *file)
 	kfree(fhp);
 	if (vp->channel.mc_head->disconnect_flag &&
 	    list_empty(&vp->dev_video->devbase.fh_list) &&
-	    list_empty(&vp->dev_radio->devbase.fh_list)) {
+	    (!vp->dev_radio ||
+	     list_empty(&vp->dev_radio->devbase.fh_list))) {
 		pvr2_v4l2_destroy_no_lock(vp);
 	}
 	return 0;
-- 
2.20.1

