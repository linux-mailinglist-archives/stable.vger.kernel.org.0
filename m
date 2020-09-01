Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B0B2592CD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgIAPRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgIAPRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:17:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F1CD206FA;
        Tue,  1 Sep 2020 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973422;
        bh=Pk1j2qWhzTS6QEG7IBMEiNngbhmF5UqUq4eXu9KMYxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpJKpvao3WDSxWDF3k85bRArCUboenXF6kjBBoSloRNiFbQR0pAHafgyeZrtSJik8
         gkDOV2xkoq4J8k4fW3eckhKAEx3JaYwv9/p2XGW5/thMdhd8AXHWp/eb192XRBMto0
         kFLabV8jyZ6oMLmZ38zcyC66EIm15o+hTVYN79N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Kees Cook <keescook@chromium.org>,
        Brooke Basile <brookebasile@gmail.com>,
        Felipe Balbi <balbi@kernel.org>, stable <stable@kernel.org>
Subject: [PATCH 4.9 72/78] USB: gadget: u_f: add overflow checks to VLA macros
Date:   Tue,  1 Sep 2020 17:10:48 +0200
Message-Id: <20200901150928.374303683@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
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
@@ -17,6 +17,7 @@
 #define __U_F_H__
 
 #include <linux/usb/gadget.h>
+#include <linux/overflow.h>
 
 /* Variable Length Array Macros **********************************************/
 #define vla_group(groupname) size_t groupname##__next = 0
@@ -24,21 +25,36 @@
 
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


