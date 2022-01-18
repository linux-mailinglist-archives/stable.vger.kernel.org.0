Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C88491577
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343620AbiARC2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244935AbiARC0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA22C061366;
        Mon, 17 Jan 2022 18:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB5DFB81244;
        Tue, 18 Jan 2022 02:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36B6C36AF2;
        Tue, 18 Jan 2022 02:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472682;
        bh=5l4Rfm2PSSLWqX7qktkfzNpaICyo5Ne2QJRlsa438hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keBMEofbuKaZpYbAxCjjdkM/s40MKBm84RHUpgs+3TtYV4dMsDBwhyFmlG/0QeFMt
         EtDCEDwioMvnPHIAsZNUNmol1bDeicex50KFyw1+kJkbfCCY83aNCXe8hAQeceR+Rb
         XW9vSHOcBHHehc0qvUPpEyvh+dp0VyHi7rsJwubGeevmxHKkFeILqKT1j/lr7EjXYW
         DjCqk6scA5BIVjghvXqRFMbHzZtWjbg/9TwOuot/JTYpE0Uh9XRZ4ocqyeAZjGtBr+
         9c+eZ7INMPN3tlBW3VITQ0RVkZuzGwxyr4hy48vKPLYq5XDqDpnW6s1UK0zYxz8G/6
         KAcDF2Z13m0Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 097/217] media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.
Date:   Mon, 17 Jan 2022 21:17:40 -0500
Message-Id: <20220118021940.1942199-97-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 2e5366143b814..143230b3275b3 100644
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

