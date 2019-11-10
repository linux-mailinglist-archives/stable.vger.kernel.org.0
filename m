Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C85F662C
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfKJCnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbfKJCnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F29621882;
        Sun, 10 Nov 2019 02:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353800;
        bh=byiQ1KJydIEPDJZeT7ApWnKgaGGor+z5jzj2loxTwys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Og0te/iNx8Wm9km9QtVQ3w73JkF+SWNGrS1dXTPBnidhDt0xywRU9iWQ3Wf7zQPpU
         pn4CHTElKKNVUEa9KPc3Op1Vsf8z3pizyJGO3BQViL2lQ6vLldosd6VM6CS92PUTO0
         Mkbz4DvB61zqsBHNeiWAXrL6hSeRfcO/fhX7NYu8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Elder <paul.elder@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 099/191] usb: gadget: uvc: configfs: Sort frame intervals upon writing
Date:   Sat,  9 Nov 2019 21:38:41 -0500
Message-Id: <20191110024013.29782-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

