Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDCF33B5CD
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhCONz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231478AbhCONyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4986964EFD;
        Mon, 15 Mar 2021 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816488;
        bh=xXxDQSqqR3snEHkyGw9YsoNZ9B7ks0X4cGv7OBxYCWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vh+7Ux0nE7TTYWAvk5zyX5re3j9wafAvRDqQUqj8eh8Sa3D4fgcW3naBt4kY4du0S
         vb/OReNrRVLO1PtiYhsJbN4UHibjTS7ps60i8CHUQe8xo3UjfH0g59XAgv99c5SObR
         zuApulGux2tjf0Hc+sh1tGRHTchGZB0TrqU2aaK0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Matt Turner <mattst88@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 68/78] alpha: Package string routines together
Date:   Mon, 15 Mar 2021 14:52:31 +0100
Message-Id: <20210315135214.292884323@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Richard Henderson <rth@twiddle.net>

commit 4758ce82e66711b1a4557577e30a5f9b88d4a4b5 upstream.

There are direct branches between {str*cpy,str*cat} and stx*cpy.
Ensure the branches are within range by merging these objects.

Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/lib/Makefile |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/alpha/lib/Makefile
+++ b/arch/alpha/lib/Makefile
@@ -20,12 +20,8 @@ lib-y =	__divqu.o __remqu.o __divlu.o __
 	checksum.o \
 	csum_partial_copy.o \
 	$(ev67-y)strlen.o \
-	$(ev67-y)strcat.o \
-	strcpy.o \
-	$(ev67-y)strncat.o \
-	strncpy.o \
-	$(ev6-y)stxcpy.o \
-	$(ev6-y)stxncpy.o \
+	stycpy.o \
+	styncpy.o \
 	$(ev67-y)strchr.o \
 	$(ev67-y)strrchr.o \
 	$(ev6-y)memchr.o \
@@ -49,3 +45,17 @@ AFLAGS___remlu.o =       -DREM -DINTSIZE
 $(addprefix $(obj)/,__divqu.o __remqu.o __divlu.o __remlu.o): \
 						$(src)/$(ev6-y)divide.S FORCE
 	$(call if_changed_rule,as_o_S)
+
+# There are direct branches between {str*cpy,str*cat} and stx*cpy.
+# Ensure the branches are within range by merging these objects.
+
+LDFLAGS_stycpy.o := -r
+LDFLAGS_styncpy.o := -r
+
+$(obj)/stycpy.o: $(obj)/strcpy.o $(obj)/$(ev67-y)strcat.o \
+		 $(obj)/$(ev6-y)stxcpy.o FORCE
+	$(call if_changed,ld)
+
+$(obj)/styncpy.o: $(obj)/strncpy.o $(obj)/$(ev67-y)strncat.o \
+		 $(obj)/$(ev6-y)stxncpy.o FORCE
+	$(call if_changed,ld)


