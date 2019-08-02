Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4857F532
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfHBKiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:38:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38214 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfHBKiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 06:38:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so76652284wrr.5
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 03:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uYEVnSEEH7/MuhxRsAsyoycRVX2aLLUAgvfdTDtL048=;
        b=sCB2TC/O2k9MbaQuxzICZw5Hs2z6Yp6wlhWo0xpb9x9aHdO8jW0QC74MdHmeEIES2M
         TrF5aDrOTok5s6o59tQvxX4kJ1ZNd8Gt6ESLFY3uXbr3PWcFzBdXvnJOaYiCO4HLr6CN
         yd9nLUbdNL5wcvNzdVknC5u/M8lOYM5HwP/5YjcQJ1iojfMutTcLyIVNOkpq1yJPTeUV
         AvfI/YJdnSO6vMGbrn2omcRman32zdApny23LdpJtIbF9gp0sp9DpIVQp6nLoXURMD9g
         IQTfJe/paf0vhnOEknWDV4tyd6xUnBpSoTtMeK/Mjl9rOFSx2XJYP62UFPZI8o/E0uSC
         ya3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uYEVnSEEH7/MuhxRsAsyoycRVX2aLLUAgvfdTDtL048=;
        b=Ss1ah8pLJZhUJa9Sjko0ZB8lS7nRhqjRqacS5acc/ZiNfynKO1wQy+y7+WDfD17qkc
         jtzundGAgYlxg6nzroIzyaUXSrQgWAj+yVIzupopozdPsyIiZU5BwQqYCCPzS9bapg4O
         3QNXcVYCCZeYgoW8P1vvzXt965FSUF/m4LV6dwU+ez5U6TwkG5jvvHBXPu8rw6yhaAQU
         s2nJYl50bnc3jDHg+nKaEZojid3pmbZSET+86HCC/jFdWutIWXbz6UN6quV/YW2McCqS
         wpJ8GRrVYm+j18oUzUiEUTYuXZBhONNukTHHJWw1OEdVCrVCTLIFpcoi9Rm6zihGa2Cz
         d0Cg==
X-Gm-Message-State: APjAAAVKeiqYeIGCTgLQnaeCb3cB4q5NJoHuuOQbmPBfQbRA9m/8dcsi
        c2vs0Wgax1Uz2QkoRbjjejc=
X-Google-Smtp-Source: APXvYqzONvjJ/RDDEKVVMfzLxXHEYq0DdmqqbpkJBpOa/sEunBT/mGp1CvJ+EikdgQsOq10dbAJA4g==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr72634842wrr.70.1564742288092;
        Fri, 02 Aug 2019 03:38:08 -0700 (PDT)
Received: from localhost.localdomain (82.159.32.155.dyn.user.ono.com. [82.159.32.155])
        by smtp.gmail.com with ESMTPSA id p18sm75788008wrm.16.2019.08.02.03.38.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 03:38:07 -0700 (PDT)
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH 1/2] Backport minimal compiler_attributes.h to support GCC 9
Date:   Fri,  2 Aug 2019 12:37:56 +0200
Message-Id: <20190802103757.31397-1-miguel.ojeda.sandonis@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This adds support for __copy to v4.9.y so that we can use it in
init/exit_module to avoid -Werror=missing-attributes errors on GCC 9.

Link: https://lore.kernel.org/lkml/259986242.BvXPX32bHu@devpool35/
Cc: <stable@vger.kernel.org>
Suggested-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 include/linux/compiler.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 80a5bc623c47..e905353f217a 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -54,6 +54,22 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 
 #ifdef __KERNEL__
 
+/*
+ * Minimal backport of compiler_attributes.h to add support for __copy
+ * to v4.9.y so that we can use it in init/exit_module to avoid
+ * -Werror=missing-attributes errors on GCC 9.
+ */
+#ifndef __has_attribute
+# define __has_attribute(x) __GCC4_has_attribute_##x
+# define __GCC4_has_attribute___copy__                0
+#endif
+
+#if __has_attribute(__copy__)
+# define __copy(symbol)                 __attribute__((__copy__(symbol)))
+#else
+# define __copy(symbol)
+#endif
+
 #ifdef __GNUC__
 #include <linux/compiler-gcc.h>
 #endif
-- 
2.17.1

