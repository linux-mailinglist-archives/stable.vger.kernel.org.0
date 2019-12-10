Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A23611956B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfLJVMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbfLJVL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3CAC24697;
        Tue, 10 Dec 2019 21:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012318;
        bh=k7/LvRIg+FVurNHsLIAF9XCyp1knTfLcFUKzl/naCUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQw/wknF5eI4tOnh5/N+b0fQz6zDIJ4bkJAcq25ssWJweYRZmCF9qOlJomcqWH5s/
         QEtKBlA4Au38torxja+IhfaZVpxhfAlnlZ8AgfgC11VgPZPld0JXBue6hkZajz+tgJ
         Dy+sIrUOsZ79FCF9yEIc/+eDkMEImx6NWk9rB7Zo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Isely <isely@pobox.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 252/350] media: pvrusb2: Fix oops on tear-down when radio support is not present
Date:   Tue, 10 Dec 2019 16:05:57 -0500
Message-Id: <20191210210735.9077-213-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
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
index a34717eba409b..eaa08c7999d4f 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -898,8 +898,12 @@ static void pvr2_v4l2_internal_check(struct pvr2_channel *chp)
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
 
@@ -935,7 +939,8 @@ static int pvr2_v4l2_release(struct file *file)
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

