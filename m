Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD0737885C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbhEJLVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237031AbhEJLLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2DC861574;
        Mon, 10 May 2021 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644788;
        bh=E81XsKLIq3tXn1p9KGS0c/UKL92M806Q/8Ap/KlSHgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWTDU0KnU2milNiUrqbD0+ssNPEB28yqs7n7NG8sCeiMlwI8IB8L4hWEnKcOPsUbs
         pse7YUpKH6ys8OvTSZC5Lm2gX6Q74YZv6KRHZ329yrdefLVLs5P+BvryJl0Oox6QhU
         0GIpuSag572XgBxC50xaOk6w7JmZQ5ROc5ovkw4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, John Nealy <jnealy3@yahoo.com>
Subject: [PATCH 5.12 223/384] media: uvcvideo: Support devices that report an OT as an entity source
Date:   Mon, 10 May 2021 12:20:12 +0200
Message-Id: <20210510102022.256673879@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 4ca052b4ea621d0002a5e5feace51f60ad5e6b23 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 32 ++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index e55cf02baad6..9a791d8ef200 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1716,6 +1716,31 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
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
+					uvc_dbg(chain->dev, DESCR,
+						"Can't connect extension unit %u in chain\n",
+						forward->id);
+					break;
+				}
+
+				forward->baSourceID[0] = source->id;
+			}
+
 			list_add_tail(&forward->chain, &chain->entities);
 			if (!found)
 				uvc_dbg_cont(PROBE, " (->");
@@ -1735,6 +1760,13 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 				return -EINVAL;
 			}
 
+			if (UVC_ENTITY_IS_OTERM(entity)) {
+				uvc_dbg(chain->dev, DESCR,
+					"Unsupported connection between output terminals %u and %u\n",
+					entity->id, forward->id);
+				break;
+			}
+
 			list_add_tail(&forward->chain, &chain->entities);
 			if (!found)
 				uvc_dbg_cont(PROBE, " (->");
-- 
2.30.2



