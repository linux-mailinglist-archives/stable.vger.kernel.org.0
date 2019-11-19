Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2AC1014F5
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbfKSFjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbfKSFjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5762071A;
        Tue, 19 Nov 2019 05:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141941;
        bh=byiQ1KJydIEPDJZeT7ApWnKgaGGor+z5jzj2loxTwys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnWZp/BlHsMtH+6OXFCjO2UTGEklGJLm4n9VmO0zVMbOv4nPoXjWkVAIzZ5rs2cQI
         P6ArdhsShGp2pJ2U7areSoFuiR4M1W2P/PIqEPsubRPDMxuASgZsh9+njWnEBKTcNk
         MLhLw521rgzNK6WMvK490/+7H2nKuD9xVS99b5Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Elder <paul.elder@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 333/422] usb: gadget: uvc: configfs: Sort frame intervals upon writing
Date:   Tue, 19 Nov 2019 06:18:50 +0100
Message-Id: <20191119051420.595225222@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Elder <paul.elder@ideasonboard.com>

[ Upstream commit 89969a842e72b1b653140a4bbddd927b242736d0 ]

There is an issue where the host is unable to tell the gadget what frame
rate it wants if the dwFrameIntervals in the interface descriptors are
not in ascending order. This means that when instantiating a uvc gadget
via configfs the user must make sure the dwFrameIntervals are in
ascending order.

Instead of silently failing the breaking of this rule, we sort the
dwFrameIntervals upon writing to configfs.

Signed-off-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_configfs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 9478a7cdb1433..2e4c0391b5836 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -9,6 +9,9 @@
  *
  * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
  */
+
+#include <linux/sort.h>
+
 #include "u_uvc.h"
 #include "uvc_configfs.h"
 
@@ -31,6 +34,14 @@ static struct configfs_attribute prefix##attr_##cname = { \
 	.show		= prefix##cname##_show,				\
 }
 
+static int uvcg_config_compare_u32(const void *l, const void *r)
+{
+	u32 li = *(const u32 *)l;
+	u32 ri = *(const u32 *)r;
+
+	return li < ri ? -1 : li == ri ? 0 : 1;
+}
+
 static inline struct f_uvc_opts *to_f_uvc_opts(struct config_item *item)
 {
 	return container_of(to_config_group(item), struct f_uvc_opts,
@@ -1134,6 +1145,8 @@ static ssize_t uvcg_frame_dw_frame_interval_store(struct config_item *item,
 	kfree(ch->dw_frame_interval);
 	ch->dw_frame_interval = frm_intrv;
 	ch->frame.b_frame_interval_type = n;
+	sort(ch->dw_frame_interval, n, sizeof(*ch->dw_frame_interval),
+	     uvcg_config_compare_u32, NULL);
 	ret = len;
 
 end:
-- 
2.20.1



