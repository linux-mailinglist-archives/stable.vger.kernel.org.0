Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155B11C15A2
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgEANbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgEANbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:31:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E647C24953;
        Fri,  1 May 2020 13:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339881;
        bh=u3WJmEf+Y+rA88Fg6ye7fFbRzFH5LlMsn1YCXE2XJ+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1sEYvQr1RXf4vmeZ7BQIFXjiG+fZ+0K7QPBiCiOabOxzhF+5NnFZDepZFPq9xYq1
         9iUcTrG9nlKmxGjdHQ/2Te+1to3TKO9MyKui33C81UT/6YRCifN83wGiYhLr3OY/aM
         BfiqBHwUo//HUhttQv+/OzbpMeEt7/aX3zBdAZ74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Morris <jmorris@namei.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <james.morris@microsoft.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 004/117] keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h
Date:   Fri,  1 May 2020 15:20:40 +0200
Message-Id: <20200501131545.904633704@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 2ecefa0a15fd0ef88b9cd5d15ceb813008136431 upstream.

The keyctl_dh_params struct in uapi/linux/keyctl.h contains the symbol
"private" which means that the header file will cause compilation failure
if #included in to a C++ program.  Further, the patch that added the same
struct to the keyutils package named the symbol "priv", not "private".

The previous attempt to fix this (commit 8a2336e549d3) did so by simply
renaming the kernel's copy of the field to dh_private, but this then breaks
existing userspace and as such has been reverted (commit 8c0f9f5b309d).

[And note, to those who think that wrapping the struct in extern "C" {}
 will work: it won't; that only changes how symbol names are presented to
 the assembler and linker.].

Instead, insert an anonymous union around the "private" member and add a
second member in there with the name "priv" to match the one in the
keyutils package.  The "private" member is then wrapped in !__cplusplus
cpp-conditionals to hide it from C++.

Fixes: ddbb41148724 ("KEYS: Add KEYCTL_DH_COMPUTE command")
Fixes: 8a2336e549d3 ("uapi/linux/keyctl.h: don't use C++ reserved keyword as a struct member name")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Randy Dunlap <rdunlap@infradead.org>
cc: Lubomir Rintel <lkundrak@v3.sk>
cc: James Morris <jmorris@namei.org>
cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
cc: Stephan Mueller <smueller@chronox.de>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>
cc: stable@vger.kernel.org
Signed-off-by: James Morris <james.morris@microsoft.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/keyctl.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -65,7 +65,12 @@
 
 /* keyctl structures */
 struct keyctl_dh_params {
-	__s32 private;
+	union {
+#ifndef __cplusplus
+		__s32 private;
+#endif
+		__s32 priv;
+	};
 	__s32 prime;
 	__s32 base;
 };


