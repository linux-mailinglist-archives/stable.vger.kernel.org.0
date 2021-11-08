Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1414944A238
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbhKIBQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242684AbhKIBOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:14:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7424614C8;
        Tue,  9 Nov 2021 01:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419946;
        bh=Z3ct+PXhYfibFj8MIozC60owx8+WE18i9w1P3KpE2z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3vWEhTxi3ErE0HRat+ArzDGEqeM4UDnBkhdX0Y7kw6BFv91W5kNagPR1KQdPCs7z
         UgGrFkjylpHPbZfZlnVmgDMJLBEKQ1A3o4btTsKPMQ9JQch4F9yWuPKOt9puu7JZKP
         uwDJKPxmzzU5hi/CYATjp40elJ81pTxh1CHPmbE6AnMJ6wd42nA03+JB37rnmnTeRn
         JEPneXjMGD+JVcN5+gwZeu4f5bHyZZKr2lkjMBHN/gZpTRw5RZtcbTQ89BuATVSFUC
         IyJ9HawXjNhJ1knmabFx+O+Q29rIzj0zlRuoatoFAUVzpxOwwucQ6lzuh8fbhB7uie
         NM7Q44pUHZr9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/47] media: uvcvideo: Return -EIO for control errors
Date:   Mon,  8 Nov 2021 12:50:01 -0500
Message-Id: <20211108175031.1190422-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit ffccdde5f0e17d2f0d788a9d831a027187890eaa ]

The device is doing something unexpected with the control. Either because
the protocol is not properly implemented or there has been a HW error.

Fixes v4l2-compliance:

Control ioctls (Input 0):
                fail: v4l2-test-controls.cpp(448): s_ctrl returned an error (22)
        test VIDIOC_G/S_CTRL: FAIL
                fail: v4l2-test-controls.cpp(698): s_ext_ctrls returned an error (22)
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 56b058d60a0dc..9c26e586bb01d 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -117,6 +117,11 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
 	case 5: /* Invalid unit */
 	case 6: /* Invalid control */
 	case 7: /* Invalid Request */
+		/*
+		 * The firmware has not properly implemented
+		 * the control or there has been a HW error.
+		 */
+		return -EIO;
 	case 8: /* Invalid value within range */
 		return -EINVAL;
 	default: /* reserved or unknown */
-- 
2.33.0

