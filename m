Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904CA491DFB
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347871AbiARDpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:45:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346058AbiARCmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:42:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75246B81263;
        Tue, 18 Jan 2022 02:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802B2C36AEB;
        Tue, 18 Jan 2022 02:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473733;
        bh=ixHiAAhTeUJ3CTD9gpQ0BpOp0z4g1efWh7BF2ublt54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cL1dQzgjQrXOIYXORx4q10YnjWZh18pFxR9ANEij+N/Tccb1e4JqQNWgUBLEkyjqL
         ivHA4/XobCxbZ/N9OJ0UNt4OBeiS414U8i+d7yYGZtjw4ku0wxwKl8Coo9O/wj/Cfa
         GFSWoGuFiaolO1vhTtK0Z8Ox/eUQwFiAQRhSnvAQJdOY6d5NQpQLTqX2kov2i4w+5v
         R9BIGl5D5xsB4SS91/HjJ3khadY6J6bHA5St/flA6FzwyBKSxkYDaNpFYE+l0GaoXn
         JpXajmC0eW/Ka6W9u7/3StjspwASTCebHsQog+xKJp79jmcZ1uKUcQv0wa+ZClBiwO
         yOT2LpECfE6LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 045/116] media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.
Date:   Mon, 17 Jan 2022 21:38:56 -0500
Message-Id: <20220118024007.1950576-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a3dfacf069c44..c884020b28784 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -183,7 +183,7 @@
 /* Maximum status buffer size in bytes of interrupt URB. */
 #define UVC_MAX_STATUS_SIZE	16
 
-#define UVC_CTRL_CONTROL_TIMEOUT	500
+#define UVC_CTRL_CONTROL_TIMEOUT	5000
 #define UVC_CTRL_STREAMING_TIMEOUT	5000
 
 /* Maximum allowed number of control mappings per device */
-- 
2.34.1

