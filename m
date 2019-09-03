Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19A5A707B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbfICQjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730402AbfICQZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41FC12377F;
        Tue,  3 Sep 2019 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527930;
        bh=8O/nJ8QsWRakObntQlxlpgwBzmx15+PaEmBLe0UqJvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEJb1tIBTTEVop6iIZjIc/ueqiFD9kKfXkAKuUrugFNiENnSMfjTodlzp6y5tDxg0
         AB0U3zplzxrvkx7MxN0yOwonn/URhhYpQ82d72HnWmpdMretcsQLedGFd9gfPssCqh
         R+2VVFop9JTvgAm5nN6gONvcCXjqKdHvJIYSkvRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Morris <jmorris@namei.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <james.morris@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, keyrings@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 005/167] keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h
Date:   Tue,  3 Sep 2019 12:22:37 -0400
Message-Id: <20190903162519.7136-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2ecefa0a15fd0ef88b9cd5d15ceb813008136431 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/keyctl.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 7b8c9e19bad1c..0f3cb13db8e93 100644
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
-- 
2.20.1

