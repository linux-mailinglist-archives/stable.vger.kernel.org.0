Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1793F34C5E5
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhC2IDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhC2IC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:02:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBAE361981;
        Mon, 29 Mar 2021 08:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004976;
        bh=ZBb9QnG7mWbrzHbYSTMzFpV6te9HFeDdkcDwdmm7FzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASr03FRaP5cyGEEIr+qwZcpptzPtX1ZnJUiITl84bW3bx1AWRHW1rjJKIwkz4/hDb
         XEcEreXsWSsPyIS1KYqKAJq5pXH0CiI1hkNMWDPknUnpcPoPob3+ERhCsKTU3nK09x
         skQUz8chiivyYEcFgICAE6HzxhT5e4vAC34YqBjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 36/53] idr: add ida_is_empty
Date:   Mon, 29 Mar 2021 09:58:11 +0200
Message-Id: <20210329075608.698857395@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

[ Upstream commit 99c494077e2d4282a17120a772eecc00ec3004cc ]

Two of the USB Gadgets were poking around in the internals of struct ida
in order to determine if it is empty.  Add the appropriate abstraction.

Link: http://lkml.kernel.org/r/1480369871-5271-63-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c     | 6 +++---
 drivers/usb/gadget/function/f_printer.c | 6 +++---
 include/linux/idr.h                     | 5 +++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 8e83649f77ce..42e5677d932d 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -932,7 +932,7 @@ static void hidg_free_inst(struct usb_function_instance *f)
 	mutex_lock(&hidg_ida_lock);
 
 	hidg_put_minor(opts->minor);
-	if (idr_is_empty(&hidg_ida.idr))
+	if (ida_is_empty(&hidg_ida))
 		ghid_cleanup();
 
 	mutex_unlock(&hidg_ida_lock);
@@ -958,7 +958,7 @@ static struct usb_function_instance *hidg_alloc_inst(void)
 
 	mutex_lock(&hidg_ida_lock);
 
-	if (idr_is_empty(&hidg_ida.idr)) {
+	if (ida_is_empty(&hidg_ida)) {
 		status = ghid_setup(NULL, HIDG_MINORS);
 		if (status)  {
 			ret = ERR_PTR(status);
@@ -971,7 +971,7 @@ static struct usb_function_instance *hidg_alloc_inst(void)
 	if (opts->minor < 0) {
 		ret = ERR_PTR(opts->minor);
 		kfree(opts);
-		if (idr_is_empty(&hidg_ida.idr))
+		if (ida_is_empty(&hidg_ida))
 			ghid_cleanup();
 		goto unlock;
 	}
diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index b962f24b500b..b3d036d06553 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1276,7 +1276,7 @@ static void gprinter_free_inst(struct usb_function_instance *f)
 	mutex_lock(&printer_ida_lock);
 
 	gprinter_put_minor(opts->minor);
-	if (idr_is_empty(&printer_ida.idr))
+	if (ida_is_empty(&printer_ida))
 		gprinter_cleanup();
 
 	mutex_unlock(&printer_ida_lock);
@@ -1300,7 +1300,7 @@ static struct usb_function_instance *gprinter_alloc_inst(void)
 
 	mutex_lock(&printer_ida_lock);
 
-	if (idr_is_empty(&printer_ida.idr)) {
+	if (ida_is_empty(&printer_ida)) {
 		status = gprinter_setup(PRINTER_MINORS);
 		if (status) {
 			ret = ERR_PTR(status);
@@ -1313,7 +1313,7 @@ static struct usb_function_instance *gprinter_alloc_inst(void)
 	if (opts->minor < 0) {
 		ret = ERR_PTR(opts->minor);
 		kfree(opts);
-		if (idr_is_empty(&printer_ida.idr))
+		if (ida_is_empty(&printer_ida))
 			gprinter_cleanup();
 		goto unlock;
 	}
diff --git a/include/linux/idr.h b/include/linux/idr.h
index 083d61e92706..3639a28188c9 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -195,6 +195,11 @@ static inline int ida_get_new(struct ida *ida, int *p_id)
 	return ida_get_new_above(ida, 0, p_id);
 }
 
+static inline bool ida_is_empty(struct ida *ida)
+{
+	return idr_is_empty(&ida->idr);
+}
+
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
-- 
2.30.1



