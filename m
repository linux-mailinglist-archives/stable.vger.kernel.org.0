Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55134971A6
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 14:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiAWNcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 08:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiAWNcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 08:32:50 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5993C06173D
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 05:32:49 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x7so43868003lfu.8
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 05:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=embecosm.com; s=google;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=DgJZK3cUl7BMrj5rlxlO6UlwlkM/loYjlJWdtr0GJoY=;
        b=Q0O21Re8JnLPbxfUWerN6Lg3yQOZSe0u+2lQHRn5RekRR4lXL0nHUTWDUanrP+Y57x
         Ql1a3vpNS95JzGzHJiSepRiaHym3Z9HTtHSuqvxUz/KEkMkwf4NRluDtccNfIXm7MmTZ
         SeLetTmfIGHwZtYbojObJ2ypFD6i17zrlBZMHq4PsTdOHr3FmRY9Ky1PFdeOylhCYriW
         18qHnP52hn6H1hZccUBpNJbMPQz0kSTFJhDfSm/Htlp61N0xtnVlYRPX3S0Y1NvraSLU
         aVww7pE6O7gtf5OwvtvEPyXhhvEpQoPu7FKoUN79sVk6FAfg93RFcvoGooeqBzaoQ9Ln
         qjgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=DgJZK3cUl7BMrj5rlxlO6UlwlkM/loYjlJWdtr0GJoY=;
        b=sMoe1AYmRJulN+5XQPzc+g/lhHPahbT2zycTRC/qPElabKmw8pFxDPJ7OTtKABomCn
         1gp7/50fDTsoTTDY3/Yt7fP+hKCyN/VO0cm3N6KlShCOViABEaEKiqZ+WoB1jKu7mfJr
         bThHZPoDudb9s1x6+vomvIjk2UGDO00/VDdV5BiNawrwjblJe9mOmrUgf6N/gaScTetR
         okR8fjwNBd8XfmqI2CVR0hnIraK/Afnd5eL8gPBYHDXmCtuDNVjseMRkQXYt2LSShpXK
         CIrVEGBRO9zJuTuN7SVkaXzLlbnmMFndHp/tWg9ojA6LDtLxwXsVxK/au0g5Q+LV3VMV
         jiqA==
X-Gm-Message-State: AOAM532r8XuivBR42YRB3d6AerV33bjq07ubIaF2nOi05sJOMjr7F0Ee
        XYoNzfxA0JcV14J6iPo6MHe2MQ==
X-Google-Smtp-Source: ABdhPJxrrBThy4A7zTLsSM+XjyuOA3Msy67kGLUf3itrmMeHkGymJqIByspP1XpbbkustgvVhSiOmQ==
X-Received: by 2002:ac2:5442:: with SMTP id d2mr2734150lfn.482.1642944768092;
        Sun, 23 Jan 2022 05:32:48 -0800 (PST)
Received: from [192.168.219.3] ([78.8.192.131])
        by smtp.gmail.com with ESMTPSA id b18sm52831lff.109.2022.01.23.05.32.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jan 2022 05:32:47 -0800 (PST)
Date:   Sun, 23 Jan 2022 13:32:45 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@embecosm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] tty: Partially revert the removal of the Cyclades public
 API
Message-ID: <alpine.DEB.2.20.2201230148120.11348@tpp.orcam.me.uk>
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
ioctl numbers back then so as to make the library build again.

References:

[1] GCC PR sanitizer/100379, "cyclades.h is removed from linux kernel 
    header files", <https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100379>

Signed-off-by: Maciej W. Rozycki <macro@embecosm.com>
Fixes: f76edd8f7ce0 ("tty: cyclades, remove this orphan")
Cc: stable@vger.kernel.org # v5.13+
---
Hi Greg,

 Only these ioctl numbers are referred by libsanitizer (quoted with source
line numbers as printed by GCC):

  836 |   unsigned IOCTL_CYGETDEFTHRESH = CYGETDEFTHRESH;
  837 |   unsigned IOCTL_CYGETDEFTIMEOUT = CYGETDEFTIMEOUT;
  838 |   unsigned IOCTL_CYGETMON = CYGETMON;
  839 |   unsigned IOCTL_CYGETTHRESH = CYGETTHRESH;
  840 |   unsigned IOCTL_CYGETTIMEOUT = CYGETTIMEOUT;
  841 |   unsigned IOCTL_CYSETDEFTHRESH = CYSETDEFTHRESH;
  842 |   unsigned IOCTL_CYSETDEFTIMEOUT = CYSETDEFTIMEOUT;
  843 |   unsigned IOCTL_CYSETTHRESH = CYSETTHRESH;
  844 |   unsigned IOCTL_CYSETTIMEOUT = CYSETTIMEOUT;

-- however I don't think it makes sense to bring them back selectively.  

 Please apply.

  Maciej

Changes from v1:

- Adjust heading from "tty: Revert the removal of the Cyclades public API".

- Only revert `struct cyclades_monitor' and ioctl numbers.

- Properly format the change given that it's not a plain revert anymore.
---
 include/uapi/linux/cyclades.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

linux-uapi-cyclades.diff
Index: linux/include/uapi/linux/cyclades.h
===================================================================
--- /dev/null
+++ linux/include/uapi/linux/cyclades.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_CYCLADES_H
+#define _UAPI_LINUX_CYCLADES_H
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
