Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B79499C69
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579299AbiAXWFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456635AbiAXVzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503EDC07E294;
        Mon, 24 Jan 2022 12:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E385561535;
        Mon, 24 Jan 2022 20:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC45C340E5;
        Mon, 24 Jan 2022 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056556;
        bh=FxcP2RgsoTRkS8NgbR8HIDQitWFPSxNhzfk712i6GBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehLcWXjCZX2lTk4yB7jtyXdOpUzgz2/xcgVLLtVFH8RbcLetcuk3Ipuk7SVfOZAQf
         cg6KlFI65FJh5dXM93OWflhrFinhO6wmwY8Vw6aAZ2R+ry36x5c289l6jWqylEumlb
         0llu3hzxATJ4I40rImPPIVQkK5yJX0QVQDMhrtoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hilliard <james.hilliard1@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 523/846] media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.
Date:   Mon, 24 Jan 2022 19:40:40 +0100
Message-Id: <20220124184119.058010210@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit c8ed7d2f614cd8b315981d116c7a2fb01829500d ]

Some uvc devices appear to require the maximum allowed USB timeout
for GET_CUR/SET_CUR requests.

So lets just bump the UVC control timeout to 5 seconds which is the
same as the usb ctrl get/set defaults:
USB_CTRL_GET_TIMEOUT 5000
USB_CTRL_SET_TIMEOUT 5000

It fixes the following runtime warnings:
   Failed to query (GET_CUR) UVC control 11 on unit 2: -110 (exp. 1).
   Failed to query (SET_CUR) UVC control 3 on unit 2: -110 (exp. 2).

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvcvideo.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index cce5e38133cd3..c3ea6a53869f5 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -189,7 +189,7 @@
 /* Maximum status buffer size in bytes of interrupt URB. */
 #define UVC_MAX_STATUS_SIZE	16
 
-#define UVC_CTRL_CONTROL_TIMEOUT	500
+#define UVC_CTRL_CONTROL_TIMEOUT	5000
 #define UVC_CTRL_STREAMING_TIMEOUT	5000
 
 /* Maximum allowed number of control mappings per device */
-- 
2.34.1



