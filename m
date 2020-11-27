Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5300A2C6771
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 15:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbgK0OGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 09:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730811AbgK0OGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 09:06:22 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 335DF206CA;
        Fri, 27 Nov 2020 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606485980;
        bh=SyQYbFVWej1dCizjJLkWeWMarU7Ofwrc9xiAS6qec0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3Cow3j4D1FvqGayo0yxGjgkg8Q0TKe2kR1nqvRYCl0dIoJofAcro9e/2TAINP7W2
         pLW4fN/uHzJwQiEjMpJ9tusAHL6jUnT//TAh1NsPNjX5FfVUSsN1JGg0iFkCIwIlcl
         TdYOpWZGwEseYW9STd4kzjPkhAkG/YZyDGzosFPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     balbi@kernel.org
Cc:     peter.chen@nxp.com, willmcvicker@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "taehyun.cho" <taehyun.cho@samsung.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 4/5] USB: gadget: f_fs: add SuperSpeed Plus support
Date:   Fri, 27 Nov 2020 15:05:58 +0100
Message-Id: <20201127140559.381351-5-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127140559.381351-1-gregkh@linuxfoundation.org>
References: <20201127140559.381351-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "taehyun.cho" <taehyun.cho@samsung.com>

Setup the descriptors for SuperSpeed Plus for f_fs. This allows the
gadget to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
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

