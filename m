Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A764A4253
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359516AbiAaLLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42662 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376717AbiAaLIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6A360ECF;
        Mon, 31 Jan 2022 11:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1F0C340E8;
        Mon, 31 Jan 2022 11:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627335;
        bh=CF/4MY7FKckAGskhdW8kSRtZt/dF4cnf9veiaqT7nkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyWoezdi7gRs0se67aSL1Z1MUhUXH/qh8E/sIfimsozvmHz6GeKB0H+6iiAN2ilUL
         eJocobwj4n0rKpBdqUc9gx0yz4wpXi0zxxoG/A5jIiYz4bX5bKNAkBlg1LtJnPMvU8
         ExuIF3WwTCQKWhHAtT/0ZU1TZgy2E1kkbCDEoG88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Maciej W. Rozycki" <macro@embecosm.com>
Subject: [PATCH 5.15 050/171] tty: Partially revert the removal of the Cyclades public API
Date:   Mon, 31 Jan 2022 11:55:15 +0100
Message-Id: <20220131105231.721191500@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@embecosm.com>

commit f23653fe64479d96910bfda2b700b1af17c991ac upstream.

Fix a user API regression introduced with commit f76edd8f7ce0 ("tty:
cyclades, remove this orphan"), which removed a part of the API and
caused compilation errors for user programs using said part, such as
GCC 9 in its libsanitizer component[1]:

.../libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc:160:10: fatal error: linux/cyclades.h: No such file or directory
  160 | #include <linux/cyclades.h>
      |          ^~~~~~~~~~~~~~~~~~
compilation terminated.
make[4]: *** [Makefile:664: sanitizer_platform_limits_posix.lo] Error 1

As the absolute minimum required bring `struct cyclades_monitor' and
ioctl numbers back then so as to make the library build again.  Add a
preprocessor warning as to the obsolescence of the features provided.


[1] GCC PR sanitizer/100379, "cyclades.h is removed from linux kernel
    header files", <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100379>

Fixes: f76edd8f7ce0 ("tty: cyclades, remove this orphan")
Cc: stable@vger.kernel.org # v5.13+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Maciej W. Rozycki <macro@embecosm.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/cyclades.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 include/uapi/linux/cyclades.h

--- /dev/null
+++ b/include/uapi/linux/cyclades.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_CYCLADES_H
+#define _UAPI_LINUX_CYCLADES_H
+
+#warning "Support for features provided by this header has been removed"
+#warning "Please consider updating your code"
+
+struct cyclades_monitor {
+	unsigned long int_count;
+	unsigned long char_count;
+	unsigned long char_max;
+	unsigned long char_last;
+};
+
+#define CYGETMON		0x435901
+#define CYGETTHRESH		0x435902
+#define CYSETTHRESH		0x435903
+#define CYGETDEFTHRESH		0x435904
+#define CYSETDEFTHRESH		0x435905
+#define CYGETTIMEOUT		0x435906
+#define CYSETTIMEOUT		0x435907
+#define CYGETDEFTIMEOUT		0x435908
+#define CYSETDEFTIMEOUT		0x435909
+#define CYSETRFLOW		0x43590a
+#define CYGETRFLOW		0x43590b
+#define CYSETRTSDTR_INV		0x43590c
+#define CYGETRTSDTR_INV		0x43590d
+#define CYZSETPOLLCYCLE		0x43590e
+#define CYZGETPOLLCYCLE		0x43590f
+#define CYGETCD1400VER		0x435910
+#define CYSETWAIT		0x435912
+#define CYGETWAIT		0x435913
+
+#endif /* _UAPI_LINUX_CYCLADES_H */


