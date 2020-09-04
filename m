Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0195225DB8C
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgIDOZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbgIDNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:34:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9447D215A4;
        Fri,  4 Sep 2020 13:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226260;
        bh=JwQ7xpsQPSQRg6LDxLlqmQ2JIHnKRfij90mKN1gXFYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6AHYyO3GqRo3IC5qeXG/l9MlHYkZe7syAhPGBckTYKFBhrkF8Hr/3tnmYs153ftA
         TQ4FREpjJfWcEu9a8brZFZZ7+cduakZ4ZlZ0MzMoQqlPpXWA9dHBa0v4DpFs6dSKvR
         nK3Gh3CUA7CdeEyHO0VUh6Lg+FqhgKeokmt3bEhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 05/17] selftests/x86/test_vsyscall: Improve the process_vm_readv() test
Date:   Fri,  4 Sep 2020 15:30:04 +0200
Message-Id: <20200904120258.245905910@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
References: <20200904120257.983551609@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 8891adc61dce2a8a41fc0c23262b681c3ec4b73a upstream.

The existing code accepted process_vm_readv() success or failure as long
as it didn't return garbage.  This is too weak: if the vsyscall page is
readable, then process_vm_readv() should succeed and, if the page is not
readable, then it should fail.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/x86/test_vsyscall.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -462,6 +462,17 @@ static int test_vsys_x(void)
 	return 0;
 }
 
+/*
+ * Debuggers expect ptrace() to be able to peek at the vsyscall page.
+ * Use process_vm_readv() as a proxy for ptrace() to test this.  We
+ * want it to work in the vsyscall=emulate case and to fail in the
+ * vsyscall=xonly case.
+ *
+ * It's worth noting that this ABI is a bit nutty.  write(2) can't
+ * read from the vsyscall page on any kernel version or mode.  The
+ * fact that ptrace() ever worked was a nice courtesy of old kernels,
+ * but the code to support it is fairly gross.
+ */
 static int test_process_vm_readv(void)
 {
 #ifdef __x86_64__
@@ -477,8 +488,12 @@ static int test_process_vm_readv(void)
 	remote.iov_len = 4096;
 	ret = process_vm_readv(getpid(), &local, 1, &remote, 1, 0);
 	if (ret != 4096) {
-		printf("[OK]\tprocess_vm_readv() failed (ret = %d, errno = %d)\n", ret, errno);
-		return 0;
+		/*
+		 * We expect process_vm_readv() to work if and only if the
+		 * vsyscall page is readable.
+		 */
+		printf("[%s]\tprocess_vm_readv() failed (ret = %d, errno = %d)\n", vsyscall_map_r ? "FAIL" : "OK", ret, errno);
+		return vsyscall_map_r ? 1 : 0;
 	}
 
 	if (vsyscall_map_r) {
@@ -488,6 +503,9 @@ static int test_process_vm_readv(void)
 			printf("[FAIL]\tIt worked but returned incorrect data\n");
 			return 1;
 		}
+	} else {
+		printf("[FAIL]\tprocess_rm_readv() succeeded, but it should have failed in this configuration\n");
+		return 1;
 	}
 #endif
 


