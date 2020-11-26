Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF31A2C5B59
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 19:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404630AbgKZSCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 13:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404528AbgKZSCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 13:02:50 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C73B21D81;
        Thu, 26 Nov 2020 18:02:49 +0000 (UTC)
From:   Greg Kroah-Hartman <gregkh@google.com>
To:     balbi@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "taehyun.cho" <taehyun.cho@samsung.com>,
        Peter Chen <peter.chen@nxp.com>,
        stable <stable@vger.kernel.org>,
        Will McVicker <willmcvicker@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] USB: gadget: f_fs: add SuperSpeed Plus support
Date:   Thu, 26 Nov 2020 19:02:34 +0100
Message-Id: <20201126180235.254523-3-gregkh@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126180235.254523-1-gregkh@google.com>
References: <20201126180235.254523-1-gregkh@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "taehyun.cho" <taehyun.cho@samsung.com>

Setup the descriptors for SuperSpeed Plus for f_fs. This allows the
gadget to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 046f770a76da..a34a7c96a1ab 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1327,6 +1327,7 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 		struct usb_endpoint_descriptor *desc;
 
 		switch (epfile->ffs->gadget->speed) {
+		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 			desc_idx = 2;
 			break;
@@ -3222,6 +3223,10 @@ static int _ffs_func_bind(struct usb_configuration *c,
 	func->function.os_desc_n =
 		c->cdev->use_os_string ? ffs->interfaces_count : 0;
 
+	if (likely(super)) {
+		func->function.ssp_descriptors =
+			usb_copy_descriptors(func->function.ss_descriptors);
+	}
 	/* And we're done */
 	ffs_event_add(ffs, FUNCTIONFS_BIND);
 	return 0;
-- 
2.29.2

