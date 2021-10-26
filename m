Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5871743AF91
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhJZJ6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233386AbhJZJ63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49B976108D;
        Tue, 26 Oct 2021 09:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635242166;
        bh=/ilLyt2le3FT2bWtymL6pE9ixHdnwtGauLPFZAdNzf4=;
        h=From:To:Cc:Subject:Date:From;
        b=fBk/gxjYOid3GvSxoecTMfLLCt1WQli0HRS1Fac9hQeLiLZWqQKykXPfUwz30bjdY
         59WnlWjjGj9a5W0GAV0J7D3ZloCxAdToqvmgD2WDSMWl/n4xUbuPmxXa+LjuUYBVuN
         315yyA69g8ZQGrgd0naEksXw9x4EIxmVgg2/Cugmz7Tu2k8zvGQ7hD3CRQbrVkoO1n
         gFzQhC7XpGGJQtZW3jEr4Jz+Uk8jK53gxO1N/rdTi7w4un1YcG/Pk23NDUIEqKJfLL
         U6Fz3fYubJvieAhvW32rbMdqCEZni73LdKoB8ZzDDMWzeJmRSB41721c0OkONH1TwZ
         yLUfexoktL8yg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfJBN-0006x9-Vy; Tue, 26 Oct 2021 11:55:50 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] media: uvcvideo: fix division by zero at stream start
Date:   Tue, 26 Oct 2021 11:55:11 +0200
Message-Id: <20211026095511.26673-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the missing bulk-endpoint max-packet sanity check to probe() to
avoid division by zero in uvc_alloc_urb_buffers() in case a malicious
device has broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Cc: stable@vger.kernel.org      # 2.6.26
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index e16464606b14..85ac5c1081b6 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1958,6 +1958,10 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
 		if (ep == NULL)
 			return -EIO;
 
+		/* Reject broken descriptors. */
+		if (usb_endpoint_maxp(&ep->desc) == 0)
+			return -EIO;
+
 		ret = uvc_init_video_bulk(stream, ep, gfp_flags);
 	}
 
-- 
2.32.0

