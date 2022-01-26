Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1717B49C639
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 10:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbiAZJXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 04:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbiAZJXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 04:23:00 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB67C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 01:22:59 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id y15so53526691lfa.9
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 01:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=embecosm.com; s=google;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=oxq3ONKXLg1Y/487Gqg3QW4aZf1mljCDJdrAW5I3mhg=;
        b=cm7I7BsDJFNjJUBKlGv7hAAbHygibT6PoqAhpR6aAYwMTQEBAF1WB7rK8o7oHYXYOU
         ikD/+UDIO/i5qjfstDYzj/ho0udxh2mzCez+ISQcE6a/RVKm3WcNFRhS2x76NmqtCbEW
         3EKuZgOR0er4uK1qLbj4qwN+hSRpIVs0tGAV02ei9xC/CcVVSohtoCkMCakQPCOPB8G8
         1mPRM4I9r6M4H4ZP9VFtNHNfw4/QU410drd0XFyuZu/bT9AbPwAxoPNqbyyHLsbHhNOm
         fprFGCfiNPjG3bALCA8KT8n118j8KP6n8g9MJvLg1OlQvBGAGY76apf7TzVRnFeMyYvB
         KbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=oxq3ONKXLg1Y/487Gqg3QW4aZf1mljCDJdrAW5I3mhg=;
        b=FtmjxJvx9csnVHYipmyey4kw4eSfdLZG9OveRWT7Ne+I4g2mdo7LL5wLKSZ7gIMnAe
         t/sKgQ3B/qfAqA9lpYbnKZeP7VB98WVa598KKAoFrxxux+KJv+Qbgn0wx2XhFUf+9av5
         9F6AGhjNBJun6RPr4SgFmzKoZfy7IyO91o3YK+hVov+wQ4odKZb/DkwwTrMz2YGmNQIC
         KvmVNdfsZPrtP6z68bPs66IWNf8r/6irIOrw+qNCrfiUfQg/QdczCFh78VQzvKHCSAgy
         Peclob/nIRhF6zwc2js4hE1+XB4sPbkKL1u5Yq2U/84W7fwzQhCMfbnEUZW8WlVZPVSz
         DMgw==
X-Gm-Message-State: AOAM533sKAIMrkP2xk8QSRHM1k53/GaRlRVAXGW0zxVyxsktExqmwPGR
        nc19B+8tr7YByMMfWfO5pnCPRg==
X-Google-Smtp-Source: ABdhPJwvPaCPS5CLF98P0Mkrjfe4wx0bAVFGthGkIN7HKtRCzPMNhkIMroK0rCznCe3EahhIVvnW/A==
X-Received: by 2002:a05:6512:132a:: with SMTP id x42mr3836612lfu.2.1643188978245;
        Wed, 26 Jan 2022 01:22:58 -0800 (PST)
Received: from [192.168.219.3] ([78.8.192.131])
        by smtp.gmail.com with ESMTPSA id b39sm1501589ljr.88.2022.01.26.01.22.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 01:22:57 -0800 (PST)
Date:   Wed, 26 Jan 2022 09:22:54 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@embecosm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
cc:     Christoph Hellwig <hch@infradead.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] tty: Partially revert the removal of the Cyclades public
 API
Message-ID: <alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

References:

[1] GCC PR sanitizer/100379, "cyclades.h is removed from linux kernel 
    header files", <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100379>

Signed-off-by: Maciej W. Rozycki <macro@embecosm.com>
Fixes: f76edd8f7ce0 ("tty: cyclades, remove this orphan")
Cc: stable@vger.kernel.org # v5.13+
---
Changes from v2:

- Add #warning directives.

Changes from v1:

- Adjust heading from "tty: Revert the removal of the Cyclades public API".

- Only revert `struct cyclades_monitor' and ioctl numbers.

- Properly format the change given that it's not a plain revert anymore.
---
 include/uapi/linux/cyclades.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

linux-uapi-cyclades.diff
Index: linux/include/uapi/linux/cyclades.h
===================================================================
--- /dev/null
+++ linux/include/uapi/linux/cyclades.h
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
