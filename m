Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC8312C5A3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfL2RjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbfL2RdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F35C24125;
        Sun, 29 Dec 2019 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640798;
        bh=QiEcSKWtt9/YX+Rd2TW93R6G0pJTiBxnRk1De19FmmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BblYJVIaJ1RDIL+ind1Gzdz5k0L1R4TfAU+yI9QbrNuc8wna/3dFawkIsuzhCZz0q
         FbiKzSVoFLdbnHHmFeChUwmgOGaRVWFy5iKxqNMdHekSvJxCIERuCRQKdgQCF7f/ZR
         zVe+w+QyOAGIoFtZ2RvGH7E7hnFRGyC7PmFP8Ics=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Isely <isely@pobox.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/219] media: pvrusb2: Fix oops on tear-down when radio support is not present
Date:   Sun, 29 Dec 2019 18:19:06 +0100
Message-Id: <20191229162530.188135670@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e53a80b589a1..04d334152eae 100644
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



