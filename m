Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87E73C24CB
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhGINZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhGINY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BFED613DF;
        Fri,  9 Jul 2021 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836935;
        bh=oivGVAIQvMsCCB509axjCQS+tcLrcPCpKaj3aX8XSMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqspY9Vku3YFEIIZ7Iq9oW0VPj4aZQanYCZVh8mHLhnyL77/s/59Gwv6JNhqILaAz
         3pyJuLFdkudalKrE8jqVg4DjjwDPXG2hTCQ5ZeD5qOOPdqNUrMQ3qcUxvSQVaKjh2i
         fhnvGlDpupsqpSynD9ZOqHEe6/cxzv4DURC76h3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Nealy <jnealy3@yahoo.com>
Subject: [PATCH 5.10 2/6] media: uvcvideo: Support devices that report an OT as an entity source
Date:   Fri,  9 Jul 2021 15:21:11 +0200
Message-Id: <20210709131539.850852647@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
References: <20210709131537.035851348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 4ca052b4ea621d0002a5e5feace51f60ad5e6b23 upstream.

Some devices reference an output terminal as the source of extension
units. This is incorrect, as output terminals only have an input pin,
and thus can't be connected to any entity in the forward direction. The
resulting topology would cause issues when registering the media
controller graph. To avoid this problem, connect the extension unit to
the source of the output terminal instead.

While at it, and while no device has been reported to be affected by
this issue, also handle forward scans where two output terminals would
be connected together, and skip the terminals found through such an
invalid connection.

Reported-and-tested-by: John Nealy <jnealy3@yahoo.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1588,6 +1588,31 @@ static int uvc_scan_chain_forward(struct
 				return -EINVAL;
 			}
 
+			/*
+			 * Some devices reference an output terminal as the
+			 * source of extension units. This is incorrect, as
+			 * output terminals only have an input pin, and thus
+			 * can't be connected to any entity in the forward
+			 * direction. The resulting topology would cause issues
+			 * when registering the media controller graph. To
+			 * avoid this problem, connect the extension unit to
+			 * the source of the output terminal instead.
+			 */
+			if (UVC_ENTITY_IS_OTERM(entity)) {
+				struct uvc_entity *source;
+
+				source = uvc_entity_by_id(chain->dev,
+							  entity->baSourceID[0]);
+				if (!source) {
+					uvc_trace(UVC_TRACE_DESCR,
+						"Can't connect extension unit %u in chain\n",
+						forward->id);
+					break;
+				}
+
+				forward->baSourceID[0] = source->id;
+			}
+
 			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)
@@ -1608,6 +1633,13 @@ static int uvc_scan_chain_forward(struct
 				return -EINVAL;
 			}
 
+			if (UVC_ENTITY_IS_OTERM(entity)) {
+				uvc_trace(UVC_TRACE_DESCR,
+					"Unsupported connection between output terminals %u and %u\n",
+					entity->id, forward->id);
+				break;
+			}
+
 			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)


