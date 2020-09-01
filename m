Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DF825941A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbgIAPfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731170AbgIAPfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17113205F4;
        Tue,  1 Sep 2020 15:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974542;
        bh=Oz7t0NWmXB5bAB+zgwUm8UAx3M15rm8xgTdMeCo8jq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlXaIaNGLDdqu8/YUV53afbD9TMMnYpNgLXcasqMeoS0U2LtCLyNH74/C1AQ73iju
         0BCfCSqZq5MNwp1V2WpoiVeH/8tOxrjtDr2oWMoZh12rccUU+gQZ0Xm+9eNP+v/TIg
         vCioqWk6iLp+538f5wlnv6vkxRLpD7e44hSyiqo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Kees Cook <keescook@chromium.org>,
        Brooke Basile <brookebasile@gmail.com>,
        Felipe Balbi <balbi@kernel.org>, stable <stable@kernel.org>
Subject: [PATCH 5.4 195/214] USB: gadget: u_f: add overflow checks to VLA macros
Date:   Tue,  1 Sep 2020 17:11:15 +0200
Message-Id: <20200901151002.294183568@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brooke Basile <brookebasile@gmail.com>

commit b1cd1b65afba95971fa457dfdb2c941c60d38c5b upstream.

size can potentially hold an overflowed value if its assigned expression
is left unchecked, leading to a smaller than needed allocation when
vla_group_size() is used by callers to allocate memory.
To fix this, add a test for saturation before declaring variables and an
overflow check to (n) * sizeof(type).
If the expression results in overflow, vla_group_size() will return SIZE_MAX.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Brooke Basile <brookebasile@gmail.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/u_f.h |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

--- a/drivers/usb/gadget/u_f.h
+++ b/drivers/usb/gadget/u_f.h
@@ -14,6 +14,7 @@
 #define __U_F_H__
 
 #include <linux/usb/gadget.h>
+#include <linux/overflow.h>
 
 /* Variable Length Array Macros **********************************************/
 #define vla_group(groupname) size_t groupname##__next = 0
@@ -21,21 +22,36 @@
 
 #define vla_item(groupname, type, name, n) \
 	size_t groupname##_##name##__offset = ({			       \
-		size_t align_mask = __alignof__(type) - 1;		       \
-		size_t offset = (groupname##__next + align_mask) & ~align_mask;\
-		size_t size = (n) * sizeof(type);			       \
-		groupname##__next = offset + size;			       \
+		size_t offset = 0;					       \
+		if (groupname##__next != SIZE_MAX) {			       \
+			size_t align_mask = __alignof__(type) - 1;	       \
+			size_t offset = (groupname##__next + align_mask)       \
+					 & ~align_mask;			       \
+			size_t size = array_size(n, sizeof(type));	       \
+			if (check_add_overflow(offset, size,		       \
+					       &groupname##__next)) {          \
+				groupname##__next = SIZE_MAX;		       \
+				offset = 0;				       \
+			}						       \
+		}							       \
 		offset;							       \
 	})
 
 #define vla_item_with_sz(groupname, type, name, n) \
-	size_t groupname##_##name##__sz = (n) * sizeof(type);		       \
-	size_t groupname##_##name##__offset = ({			       \
-		size_t align_mask = __alignof__(type) - 1;		       \
-		size_t offset = (groupname##__next + align_mask) & ~align_mask;\
-		size_t size = groupname##_##name##__sz;			       \
-		groupname##__next = offset + size;			       \
-		offset;							       \
+	size_t groupname##_##name##__sz = array_size(n, sizeof(type));	        \
+	size_t groupname##_##name##__offset = ({			        \
+		size_t offset = 0;						\
+		if (groupname##__next != SIZE_MAX) {				\
+			size_t align_mask = __alignof__(type) - 1;		\
+			size_t offset = (groupname##__next + align_mask)	\
+					 & ~align_mask;				\
+			if (check_add_overflow(offset, groupname##_##name##__sz,\
+							&groupname##__next)) {	\
+				groupname##__next = SIZE_MAX;			\
+				offset = 0;					\
+			}							\
+		}								\
+		offset;								\
 	})
 
 #define vla_ptr(ptr, groupname, name) \


