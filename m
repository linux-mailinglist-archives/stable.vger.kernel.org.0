Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC257233B8A
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 00:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgG3WqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 18:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbgG3WqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 18:46:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778E5C061575
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 15:46:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t18so19399929plo.13
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 15:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nxP2fPsBjuLaGOnJV2PoctyTt9HEnsA8L8JDsWYdkGs=;
        b=KeQRs5P9ew2DCJuY+M3CRlFIQjO3m8TNGL7YPT1yXAaZfGSylk6BIYxBtdGhvil/Ss
         ljoeXefdtoexVULGZzypQj5Oz/JmHBezN/UqXxhjkRIGoFNI7XVHetAcIQdgyVI32dg3
         7BTDhMS8RJnf46s+eHaoJV71PDCq0JNiTUXnaOz+no7SCf4yheXzYEuCslAFJ0odgXka
         DsGUBo79d4p/i9/cMudzqJwCWvCocHR6GF+Xe8jtr4c4LXUm+BYEf000ml26uyDXo3vm
         +lEivQeCo/PwMLZO3UWaMCfDudWt47LTXtis9ovz7vclBQW5EgOyaJxK0JppgnceeyFf
         MtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nxP2fPsBjuLaGOnJV2PoctyTt9HEnsA8L8JDsWYdkGs=;
        b=eTHzXfAE5jEtFE+qD+SIENiEUuwBFhyp5P5sgdzj1CkvXYEj01U0HJuOyCDUuIOPIO
         h1LgGDva9Z3No/g9GK9p55bE8rrmYAt7eW2gUBZzXQIBben7KPIqclmDzLlYoqyw1dSR
         cfoD/S/a0LzW1BNBuH29g9kMlUcPRAfeLcEO23FnKTtZdzLsbo558JE74iea9Y1oCOqu
         gEX6fnSisALmQQLTO6EcARWmCoUlTNKg1QA4bzQH+gOFZG1pxqGBb6kTzF9hrSSGzQgK
         EPUBNeduhPk/c1sxTzxxLiOm3JzOkzvu2GL/FJM5B2JPFi9RpP0G4mzl/UbOxm6TmX8u
         KskA==
X-Gm-Message-State: AOAM532+TML3PnLf8KXpX7E9Y0OYYJ5WDf0IeeeAJYWwx4rgrjNPEPmH
        x8ZCz+z6twmaZubbnao3KG1ke/CFO3jlVCPWfCU=
X-Google-Smtp-Source: ABdhPJyxLPs7XttU9ug/fEo70OLgEg1uxpiUznOI71yyHWeiiaIucGy64+/wfZyIf6mQtLMUzZh8SZkifKavPrl6d9Y=
X-Received: by 2002:a17:90a:d42:: with SMTP id 2mr1254368pju.15.1596149175923;
 Thu, 30 Jul 2020 15:46:15 -0700 (PDT)
Date:   Thu, 30 Jul 2020 15:45:54 -0700
In-Reply-To: <20200730224555.2142154-1-ndesaulniers@google.com>
Message-Id: <20200730224555.2142154-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200730224555.2142154-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH v2 1/2] tracepoint: mark __tracepoint_string's __used
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Tim Murray <timmurray@google.com>,
        Simon MacMullen <simonmacm@google.com>,
        Greg Hackmann <ghackmann@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__tracepoint_string's have their string data stored in .rodata, and an
address to that data stored in the "__tracepoint_str" section. Functions
that refer to those strings refer to the symbol of the address. Compiler
optimization can replace those address references with references
directly to the string data. If the address doesn't appear to have other
uses, then it appears dead to the compiler and is removed. This can
break the /tracing/printk_formats sysfs node which iterates the
addresses stored in the "__tracepoint_str" section.

Like other strings stored in custom sections in this header, mark these
__used to inform the compiler that there are other non-obvious users of
the address, so they should still be emitted.

Cc: stable@vger.kernel.org
Reported-by: Tim Murray <timmurray@google.com>
Reported-by: Simon MacMullen <simonmacm@google.com>
Suggested-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
No change V1 -> V2.

 include/linux/tracepoint.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index a1fecf311621..3a5b717d92e8 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -361,7 +361,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 		static const char *___tp_str __tracepoint_string = str; \
 		___tp_str;						\
 	})
-#define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+#define __tracepoint_string	__attribute__((section("__tracepoint_str"), used))
 #else
 /*
  * tracepoint_string() is used to save the string address for userspace
-- 
2.28.0.163.g6104cc2f0b6-goog

