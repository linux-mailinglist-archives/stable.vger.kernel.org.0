Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57831E2F15
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389776AbgEZTdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389732AbgEZS4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A802086A;
        Tue, 26 May 2020 18:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519368;
        bh=/y+QFQyJ/kREw8sHAXYswzLJNRZURqb3Y2G8HC42tgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0rEQ30L/fapCAZHWNYeiHWeKrBJlkeYPoTkt03eObRtJtCgb4PLu+L0onpzQ4TV1
         yr3pw637llNIJ5qOAIxgKWGaxIhVAfckWqpdfbUMGL5Ni0H645vwN+kHAJpbz21hW3
         v0vesIHM/XvDqm1it3Dza2u00H4EUMHBH0fDBBQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 40/65] net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*
Date:   Tue, 26 May 2020 20:52:59 +0200
Message-Id: <20200526183919.654519563@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>

commit 47c3e7783be4e142b861d34b5c2e223330b05d8a upstream.

PPPOL2TP_MSG_* and L2TP_MSG_* are duplicates, and are being used
interchangeably in the kernel, so let's standardize on L2TP_MSG_*
internally, and keep PPPOL2TP_MSG_* defined in UAPI for compatibility.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/l2tp.txt |    8 ++++----
 include/uapi/linux/if_pppol2tp.h  |   13 ++++++-------
 2 files changed, 10 insertions(+), 11 deletions(-)

--- a/Documentation/networking/l2tp.txt
+++ b/Documentation/networking/l2tp.txt
@@ -177,10 +177,10 @@ setsockopt on the PPPoX socket to set a
 
 The following debug mask bits are available:
 
-PPPOL2TP_MSG_DEBUG    verbose debug (if compiled in)
-PPPOL2TP_MSG_CONTROL  userspace - kernel interface
-PPPOL2TP_MSG_SEQ      sequence numbers handling
-PPPOL2TP_MSG_DATA     data packets
+L2TP_MSG_DEBUG    verbose debug (if compiled in)
+L2TP_MSG_CONTROL  userspace - kernel interface
+L2TP_MSG_SEQ      sequence numbers handling
+L2TP_MSG_DATA     data packets
 
 If enabled, files under a l2tp debugfs directory can be used to dump
 kernel state about L2TP tunnels and sessions. To access it, the
--- a/include/uapi/linux/if_pppol2tp.h
+++ b/include/uapi/linux/if_pppol2tp.h
@@ -17,6 +17,7 @@
 
 #include <linux/types.h>
 
+#include <linux/l2tp.h>
 
 /* Structure used to connect() the socket to a particular tunnel UDP
  * socket over IPv4.
@@ -89,14 +90,12 @@ enum {
 	PPPOL2TP_SO_REORDERTO	= 5,
 };
 
-/* Debug message categories for the DEBUG socket option */
+/* Debug message categories for the DEBUG socket option (deprecated) */
 enum {
-	PPPOL2TP_MSG_DEBUG	= (1 << 0),	/* verbose debug (if
-						 * compiled in) */
-	PPPOL2TP_MSG_CONTROL	= (1 << 1),	/* userspace - kernel
-						 * interface */
-	PPPOL2TP_MSG_SEQ	= (1 << 2),	/* sequence numbers */
-	PPPOL2TP_MSG_DATA	= (1 << 3),	/* data packets */
+	PPPOL2TP_MSG_DEBUG	= L2TP_MSG_DEBUG,
+	PPPOL2TP_MSG_CONTROL	= L2TP_MSG_CONTROL,
+	PPPOL2TP_MSG_SEQ	= L2TP_MSG_SEQ,
+	PPPOL2TP_MSG_DATA	= L2TP_MSG_DATA,
 };
 
 


