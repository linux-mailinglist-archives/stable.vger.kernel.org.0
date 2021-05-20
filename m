Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189D238A820
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbhETKqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238226AbhETKoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE92461405;
        Thu, 20 May 2021 09:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504646;
        bh=TsBqVVyyjxdC9PHa8Ph95yHSL6/Vd2/seeImbmewB/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDn34r1CpXarUNmsMwHlhEr1Zr5oCRlrTN9UQ3T0GjkDXnQvfBYIpuvSjFlE3FXhF
         PyfvM66te3DoB/JECgYv1m5gg/rZyBAyEno8ULnP3Su/5puylpl0ayHTTfOxMLVUEi
         2W+ihPMBuT3W7l118QxY+4+w0Th8mNsVZFCgS49Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 017/240] usb: gadget: uvc: add bInterval checking for HS mode
Date:   Thu, 20 May 2021 11:20:09 +0200
Message-Id: <20210520092109.198352832@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index f8a1881609a2..89da34ef7b3f 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -625,7 +625,12 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 
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



