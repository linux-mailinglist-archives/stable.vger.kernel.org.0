Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DDF1AC6D1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgDPOo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409349AbgDPN7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:59:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF7F121734;
        Thu, 16 Apr 2020 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045591;
        bh=I8PHgfdD0SDvIxDAZKoac40s1IpppyWu12/+HSUbMSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZPKcc0eiQEO45bCcBNcKCC36C3wP3Z0+SfIpX/5y4d1jo7Y5ktG9Uar/VyjQYkxN
         0kTxKlIrS52qQ3P0IapTSED/MpshMGSffi6cxKsyF3mLWGNNA0b727PZbgwouJVt0j
         pifZfP2G7XC0dUsPBNsIuHdzqACbe7w0+Y9lUZZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 198/254] selftests/powerpc: Fix try-run when source tree is not writable
Date:   Thu, 16 Apr 2020 15:24:47 +0200
Message-Id: <20200416131350.920961896@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 9686813f6e9d5568bc045de0be853411e44958c8 upstream.

We added a usage of try-run to pmu/ebb/Makefile to detect if the
toolchain supported the -no-pie option.

This fails if we build out-of-tree and the source tree is not
writable, as try-run tries to write its temporary files to the current
directory. That leads to the -no-pie option being silently dropped,
which leads to broken executables with some toolchains.

If we remove the redirect to /dev/null in try-run, we see the error:

  make[3]: Entering directory '/linux/tools/testing/selftests/powerpc/pmu/ebb'
  /usr/bin/ld: cannot open output file .54.tmp: Read-only file system
  collect2: error: ld returned 1 exit status
  make[3]: Nothing to be done for 'all'.

And looking with strace we see it's trying to use a file that's in the
source tree:

  lstat("/linux/tools/testing/selftests/powerpc/pmu/ebb/.54.tmp", 0x7ffffc0f83c8)

We can fix it by setting TMPOUT to point to the $(OUTPUT) directory,
and we can verify with strace it's now trying to write to the output
directory:

  lstat("/output/kselftest/powerpc/pmu/ebb/.54.tmp", 0x7fffd1bf6bf8)

And also see that the -no-pie option is now correctly detected.

Fixes: 0695f8bca93e ("selftests/powerpc: Handle Makefile for unrecognized option")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200327095319.2347641-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/powerpc/pmu/ebb/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -7,6 +7,7 @@ noarg:
 # The EBB handler is 64-bit code and everything links against it
 CFLAGS += -m64
 
+TMPOUT = $(OUTPUT)/
 # Toolchains may build PIE by default which breaks the assembly
 no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
         $(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)


