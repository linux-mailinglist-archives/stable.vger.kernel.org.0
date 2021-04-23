Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C719C368FAF
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 11:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbhDWJqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 05:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbhDWJqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 05:46:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7377EC06174A
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 02:45:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id g5so66259018ejx.0
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 02:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r9xL3vV7hsHxa0jz4RAzpmBQrBoUSRd61yPE89/kLfI=;
        b=hQmx2UwtN5nzyHTpzZR4WpzFjbFvhVjOWaMjU/09mS2hGvKIyJQSPZvtIFjj2jus7y
         n7Jzt6/7gKZ/yeRnqaH9KEPkj/xPDja2HF+TGTfF/Xm8DdeP/KyGBBeU0s2RwBSV8A3a
         2dLYjPBng0pgYA+hgUXfnI7JtFEX1AARjG6WQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r9xL3vV7hsHxa0jz4RAzpmBQrBoUSRd61yPE89/kLfI=;
        b=CYFHhd0+9ALAHKlwktOqh1SoKeHmywW+TGVJIF0Qe/Klwvnh7bFydb19rH8K3HrdPB
         x7QL/G+/Giuk1lon6PuvFlWOvpNlsG9dAwDc3NqmbP7Pba6rqrrOFKQKS/jX88vOjoBu
         JSZ2NOxGH3JA+2UTHCxTHX0yi8SEQZA5WOs5s9+OFPE0RKoVmbezNHNcT4RBMZjJOPrB
         YOAymhKGIzx0bEVmYI4uc3vIJwjSWBTCSXutT5/wWo8uOk2C/bUQpczlkcDJtScGNHIk
         pqfEflVPru6zu0xksk0cNu6L09oMgcFmoiB/qa0dvY6AuWA/d8VREg1ml+6qrED127Xn
         FNhA==
X-Gm-Message-State: AOAM533u/wH454O6J89iBsPICaF3l8jX9b6bmBoisLl5eqFJUn6Q6ORa
        1Ch5w96UBWoWESQvugo9m0ftEBH533s1bD1X
X-Google-Smtp-Source: ABdhPJwjXM4/+wZkHXmMrc0PoCbkvgYC2b6wK1ZAtFFY4bRBv0AVtL0Y3jrCK9hLI9H2amJEAtFCaA==
X-Received: by 2002:a17:907:76ae:: with SMTP id jw14mr3366109ejc.60.1619171133192;
        Fri, 23 Apr 2021 02:45:33 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([80.208.71.248])
        by smtp.gmail.com with ESMTPSA id s13sm3574225ejz.110.2021.04.23.02.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 02:45:32 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lib/vsprintf.c: remove leftover 'f' and 'F' cases from bstr_printf()
Date:   Fri, 23 Apr 2021 11:45:29 +0200
Message-Id: <20210423094529.1862521-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 9af7706492f9 ("lib/vsprintf: Remove support for %pF and %pf in
favour of %pS and %ps") removed support for %pF and %pf, and correctly
removed the handling of those cases in vbin_printf(). However, the
corresponding cases in bstr_printf() were left behind.

In the same series, %pf was re-purposed for dealing with
fwnodes (3bd32d6a2ee6, "lib/vsprintf: Add %pfw conversion specifier
for printing fwnode names").

So should anyone use %pf with the binary printf routines,
vbin_printf() would (correctly, as it involves dereferencing the
pointer) do the string formatting to the u32 array, but bstr_printf()
would not copy the string from the u32 array, but instead interpret
the first sizeof(void*) bytes of the formatted string as a pointer -
which generally won't end well (also, all subsequent get_args would be
out of sync).

Fixes: 9af7706492f9 ("lib/vsprintf: Remove support for %pF and %pf in favour of %pS and %ps")
Cc: stable@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/vsprintf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 41ddc353ebb8..39ef2e314da5 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -3135,8 +3135,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			switch (*fmt) {
 			case 'S':
 			case 's':
-			case 'F':
-			case 'f':
 			case 'x':
 			case 'K':
 			case 'e':
-- 
2.29.2

