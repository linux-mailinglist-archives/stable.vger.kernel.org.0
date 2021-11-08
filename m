Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF48744A1B5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241914AbhKIBLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237637AbhKIBJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:09:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED34D61A7E;
        Tue,  9 Nov 2021 01:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419857;
        bh=TrqC39b+5B+mLhZ+hdMZwwgK0dB5G4OJpZfPs3U+494=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLrXk0eqP5WoOnwN9u+PYqZiQAnPVwmdwocPwSW6BrspjTzobBDWe9f3l6zpFPD3n
         v+REY7wfYP8o1q3FoNCdwMCINnp9IQMglmhE4ufUl7fxH23jWRT04mKJBraHwpLAYg
         UbIz2aDUYz/BLaKegcdtjepCXVr19co1sc0a0t818J1H+1vz9aPJLKC7isw0PLIT1F
         KKYjUS8v1w0b37z9Ds5AzN1FlN5hc3CEJWC/USFpzM1CgzTvCnfoO9OzpvUhCjOewC
         y5On9fuKk9bsRum1FCehPdrXxCEsm751QLqvN9sZHkcJiFI8xl4JS/Y+XgY+tR7zu6
         JVgqV8ZRNNifQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 032/101] media: uvcvideo: Return -EIO for control errors
Date:   Mon,  8 Nov 2021 12:47:22 -0500
Message-Id: <20211108174832.1189312-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
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
index 5878c78334862..b8477fa93b7d7 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -112,6 +112,11 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
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

