Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55B2498A99
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344951AbiAXTFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:05:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59542 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345162AbiAXTCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:02:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDCCEB8122F;
        Mon, 24 Jan 2022 19:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8B0C340E5;
        Mon, 24 Jan 2022 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050966;
        bh=iQYLBwzLMi48bseQjprm7HaXg8owdAOoP16c2+NUHWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DC115jhZyzdXOYOacuYls6ZnGf+gfSLh/IlDgECaVEnkrRvfiLebjuFtjyWYoXx8X
         t90rvPYTyPC9jW9OklBtaEBGJMn2Yvez1cFeDRW+e6JTapGh/PLT039Sag6QNHzCi7
         QtTwdv8rtfKbVfGzOcvkQk4bMv5YZ1ZHRpUJyw0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 012/186] media: uvcvideo: fix division by zero at stream start
Date:   Mon, 24 Jan 2022 19:41:27 +0100
Message-Id: <20220124183937.507289946@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 8aa637bf6d70d2fb2ad4d708d8b9dd02b1c095df upstream.

Add the missing bulk-endpoint max-packet sanity check to
uvc_video_start_transfer() to avoid division by zero in
uvc_alloc_urb_buffers() in case a malicious device has broken
descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Cc: stable@vger.kernel.org      # 2.6.26
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1711,6 +1711,10 @@ static int uvc_init_video(struct uvc_str
 		if (ep == NULL)
 			return -EIO;
 
+		/* Reject broken descriptors. */
+		if (usb_endpoint_maxp(&ep->desc) == 0)
+			return -EIO;
+
 		ret = uvc_init_video_bulk(stream, ep, gfp_flags);
 	}
 


