Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177D938A226
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhETJio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232958AbhETJgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:36:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21524613BB;
        Thu, 20 May 2021 09:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503004;
        bh=/sahYzojtlrTQWRIX61Qo06k9qjoOZfkW6tCFKytgg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2NcnGoHoWnYLpPp9LjhOhspqrb44DjRblzhaYh0t1vVH+17SeTMEftHFuD2dwj/w
         T9cDTDI1zV9lTDzbX3tWsX5DyWQKL53QFlBYcYRj/va/LX3IDJMPcqViv3kf5v2GJ3
         JocP0PC3CcUZOupfYFmNTowYl2uyBKknhENvSaH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/425] usb: gadget: uvc: add bInterval checking for HS mode
Date:   Thu, 20 May 2021 11:16:34 +0200
Message-Id: <20210520092132.223649577@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 26adde04acdff14a1f28d4a5dce46a8513a3038b ]

Patch adds extra checking for bInterval passed by configfs.
The 5.6.4 chapter of USB Specification (rev. 2.0) say:
"A high-bandwidth endpoint must specify a period of 1x125 µs
(i.e., a bInterval value of 1)."

The issue was observed during testing UVC class on CV.
I treat this change as improvement because we can control
bInterval by configfs.

Reviewed-by: Peter Chen <peter.chen@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210308125338.4824-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uvc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index d8ce7868fe22..169e73ed128c 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -645,7 +645,12 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 
 	uvc_hs_streaming_ep.wMaxPacketSize =
 		cpu_to_le16(max_packet_size | ((max_packet_mult - 1) << 11));
-	uvc_hs_streaming_ep.bInterval = opts->streaming_interval;
+
+	/* A high-bandwidth endpoint must specify a bInterval value of 1 */
+	if (max_packet_mult > 1)
+		uvc_hs_streaming_ep.bInterval = 1;
+	else
+		uvc_hs_streaming_ep.bInterval = opts->streaming_interval;
 
 	uvc_ss_streaming_ep.wMaxPacketSize = cpu_to_le16(max_packet_size);
 	uvc_ss_streaming_ep.bInterval = opts->streaming_interval;
-- 
2.30.2



