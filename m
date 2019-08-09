Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC3187BE5
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406981AbfHINsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436640AbfHINrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDFF52086D;
        Fri,  9 Aug 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358474;
        bh=XnHpOzwAsLZq2SZatfzb3BcPviuZ9W76W8V6MKSCvv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQx03a4bPqHS5h2rBm1e166TdW5qW9sSqsB28G0PLcYpGInnixkYgN8vTfXwXrPuN
         gD50Mlgbh0h8pq1Ls9VYUNpEMfU5/fMsOVscthPwtEaIDBYVxkxjD+Ug3nZqtKS2Bt
         RfSTm7qMcb0NHm1hR8Dk2WA+eYHs6LWOhFi6wA44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Alex Elder <elder@linaro.org>
Subject: [PATCH 4.9 14/32] libceph: use kbasename() and kill ceph_file_part()
Date:   Fri,  9 Aug 2019 15:45:17 +0200
Message-Id: <20190809133923.428258389@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 6f4dbd149d2a151b89d1a5bbf7530ee5546c7908 upstream.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ceph/ceph_debug.h |    6 +++---
 net/ceph/ceph_common.c          |   13 -------------
 2 files changed, 3 insertions(+), 16 deletions(-)

--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -3,6 +3,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/string.h>
+
 #ifdef CONFIG_CEPH_LIB_PRETTYDEBUG
 
 /*
@@ -12,12 +14,10 @@
  */
 
 # if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
-extern const char *ceph_file_part(const char *s, int len);
 #  define dout(fmt, ...)						\
 	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
-		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
-		 __LINE__, ##__VA_ARGS__)
+		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
 # else
 /* faux printk call just to see any compiler warnings. */
 #  define dout(fmt, ...)	do {				\
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -45,19 +45,6 @@ bool libceph_compatible(void *data)
 }
 EXPORT_SYMBOL(libceph_compatible);
 
-/*
- * find filename portion of a path (/foo/bar/baz -> baz)
- */
-const char *ceph_file_part(const char *s, int len)
-{
-	const char *e = s + len;
-
-	while (e != s && *(e-1) != '/')
-		e--;
-	return e;
-}
-EXPORT_SYMBOL(ceph_file_part);
-
 const char *ceph_msg_type_name(int type)
 {
 	switch (type) {


