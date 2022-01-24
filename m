Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61CE4991AC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355216AbiAXUNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379358AbiAXULU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FF5C06F8D4;
        Mon, 24 Jan 2022 11:33:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91CA3B811FC;
        Mon, 24 Jan 2022 19:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF652C340E5;
        Mon, 24 Jan 2022 19:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052791;
        bh=qd+RMW3ekTWdd5Ghm7/F/Cbe9ZBpbdGE29aSnDE0Ntc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TY6eY/TIzB/ZXxr3IlKVOZ69EOUhUeC0JpSP1Lji8YDjZipz1ZYE3VUVUdfuaEJM+
         tb1OLvlRF/h7xSCXOs/TLfsUfPGlFN62gzzUtkWAN+wbfmSmfJxfJgvBCeT48lvjBd
         j848z2RUmpYsa5uMV0czXzMPuZx7a9RPIl7ACO/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hilliard <james.hilliard1@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/320] media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.
Date:   Mon, 24 Jan 2022 19:42:40 +0100
Message-Id: <20220124183959.647817904@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 24e3d8c647e77..5f137400bebd6 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -179,7 +179,7 @@
 /* Maximum status buffer size in bytes of interrupt URB. */
 #define UVC_MAX_STATUS_SIZE	16
 
-#define UVC_CTRL_CONTROL_TIMEOUT	500
+#define UVC_CTRL_CONTROL_TIMEOUT	5000
 #define UVC_CTRL_STREAMING_TIMEOUT	5000
 
 /* Maximum allowed number of control mappings per device */
-- 
2.34.1



