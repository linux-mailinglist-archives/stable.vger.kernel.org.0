Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82617F535
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfHBKiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:38:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38523 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfHBKiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 06:38:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so44515586wmj.3
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 03:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S+2+EUVBSWcWz2Z0VayqHRfaQ1Tp/Ak1WRItv1hrS5s=;
        b=oxQYZC75E2sT85gGwrKMKKcJkmOfGJ2riCKiYseKLRsEfzzUxPriPh7TXqD19zJ7Jj
         tIXzicfwLNZDy9b9C4U+7b1R6IrOPRnjCRyeTVRrHXmhGow7PnBq9TGp3Q5ed52o9edH
         IQO05fO+1buXwbZ/bQ/ryCblWFPMuzBt5JFQLEB89FYTJOAE2iaD5IzSTejMQ7HOibQD
         J/DGZIitphpU70UMaA8kV3VEbfg0SF8iJkqxv1BT7UolADA/ILshYlzLgVmHPya30/Ae
         N/GO6AJ9V0auM+rGfaTQgRUVPeUeoevzep83CvxSmfpsoNuD6Bgy3g/CHjhtVzmWkzIS
         Q9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S+2+EUVBSWcWz2Z0VayqHRfaQ1Tp/Ak1WRItv1hrS5s=;
        b=f89O8pRiyJ+5OuNzBySZ4WLYEFBfalafaHO+s+pBqlQSBLxL2GkPAQLabgwZ8/9Gjt
         d3HvGgtt16nUyiGtD/lPWw7D7PbjUlw02C8i3TOWpybSdjGx3w8GaYdzAc9gznRXTI63
         S2xZHI1pA8c3DZDoYgEAC15djM73hF1HxPUCkpZgJTCR2o2AqW+M3mU236q7crRrleEy
         BU97gY43x/ztG0LTWrQ2sGVqG9uO3db5fdH88SU9dUw2jJHSknAx4BUnxPepNQj0gTvT
         sdcVcZ52uQloq02A3Or3v3QhGRKXT/BXX24FvOftHibJF4Fj0G6WkOeJrJpe55GSJ9TC
         rKbg==
X-Gm-Message-State: APjAAAW5A2MWKlo6kJixOil13YXUqm4xNPv9n/ER1OiG0ryfKpL8ogUA
        R0hehi1ilZ+c/lBtvPGhQ6Q=
X-Google-Smtp-Source: APXvYqw0G8V9fcr5MJ4CiBpw7hLay7Zzthr/H2uysHcRj8KsX2peQQ2vdll8XBADOsgHUcFhBFQ4Gg==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr4150994wma.34.1564742294706;
        Fri, 02 Aug 2019 03:38:14 -0700 (PDT)
Received: from localhost.localdomain (82.159.32.155.dyn.user.ono.com. [82.159.32.155])
        by smtp.gmail.com with ESMTPSA id p18sm75788008wrm.16.2019.08.02.03.38.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 03:38:14 -0700 (PDT)
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH 2/2] include/linux/module.h: copy __init/__exit attrs to init/cleanup_module
Date:   Fri,  2 Aug 2019 12:37:57 +0200
Message-Id: <20190802103757.31397-2-miguel.ojeda.sandonis@gmail.com>
In-Reply-To: <20190802103757.31397-1-miguel.ojeda.sandonis@gmail.com>
References: <20190802103757.31397-1-miguel.ojeda.sandonis@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a6e60d84989fa0e91db7f236eda40453b0e44afa upstream.

The upcoming GCC 9 release extends the -Wmissing-attributes warnings
(enabled by -Wall) to C and aliases: it warns when particular function
attributes are missing in the aliases but not in their target.

In particular, it triggers for all the init/cleanup_module
aliases in the kernel (defined by the module_init/exit macros),
ending up being very noisy.

These aliases point to the __init/__exit functions of a module,
which are defined as __cold (among other attributes). However,
the aliases themselves do not have the __cold attribute.

Since the compiler behaves differently when compiling a __cold
function as well as when compiling paths leading to calls
to __cold functions, the warning is trying to point out
the possibly-forgotten attribute in the alias.

In order to keep the warning enabled, we decided to silence
this case. Ideally, we would mark the aliases directly
as __init/__exit. However, there are currently around 132 modules
in the kernel which are missing __init/__exit in their init/cleanup
functions (either because they are missing, or for other reasons,
e.g. the functions being called from somewhere else); and
a section mismatch is a hard error.

A conservative alternative was to mark the aliases as __cold only.
However, since we would like to eventually enforce __init/__exit
to be always marked,  we chose to use the new __copy function
attribute (introduced by GCC 9 as well to deal with this).
With it, we copy the attributes used by the target functions
into the aliases. This way, functions that were not marked
as __init/__exit won't have their aliases marked either,
and therefore there won't be a section mismatch.

Note that the warning would go away marking either the extern
declaration, the definition, or both. However, we only mark
the definition of the alias, since we do not want callers
(which only see the declaration) to be compiled as if the function
was __cold (and therefore the paths leading to those calls
would be assumed to be unlikely).

Link: https://lore.kernel.org/lkml/259986242.BvXPX32bHu@devpool35/
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/lkml/20190123173707.GA16603@gmail.com/
Link: https://lore.kernel.org/lkml/20190206175627.GA20399@gmail.com/
Suggested-by: Martin Sebor <msebor@gcc.gnu.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 include/linux/module.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index fd9e121c7b3f..99f330ae13da 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -129,13 +129,13 @@ extern void cleanup_module(void);
 #define module_init(initfn)					\
 	static inline initcall_t __maybe_unused __inittest(void)		\
 	{ return initfn; }					\
-	int init_module(void) __attribute__((alias(#initfn)));
+	int init_module(void) __copy(initfn) __attribute__((alias(#initfn)));
 
 /* This is only required if you want to be unloadable. */
 #define module_exit(exitfn)					\
 	static inline exitcall_t __maybe_unused __exittest(void)		\
 	{ return exitfn; }					\
-	void cleanup_module(void) __attribute__((alias(#exitfn)));
+	void cleanup_module(void) __copy(exitfn) __attribute__((alias(#exitfn)));
 
 #endif
 
-- 
2.17.1

