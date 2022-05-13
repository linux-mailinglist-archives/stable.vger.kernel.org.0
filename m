Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36591526414
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380759AbiEMO10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381095AbiEMO0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E827506E3;
        Fri, 13 May 2022 07:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3FB3B82C9D;
        Fri, 13 May 2022 14:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49D0C34115;
        Fri, 13 May 2022 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451985;
        bh=LAW3oRY7WSoDZ6V/paLZpl/L6DCV49O7Hv7830ybxPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXyDhOiiJRccrS99PCIsAaKHP9Sfl/W3GtF8OHGZsFeNJgYw2vkdj9lmReCuZSkNW
         25YoqfN66gr42evUIl7QNmeNuCH8IypHBLMZpk/+Qzxuxtc4VAsZSMj+3y3daylWvL
         POShwnNedeIhzgznHSIRDIqrnyaAvDkMlZKy4y9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>, xen-devel@lists.xenproject.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.4 10/18] x86/asm: Allow to pass macros to __ASM_FORM()
Date:   Fri, 13 May 2022 16:23:36 +0200
Message-Id: <20220513142229.456082257@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
References: <20220513142229.153291230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit f7919fd943abf0c77aed4441ea9897a323d132f5 upstream.

Use __stringify() at __ASM_FORM() so that user can pass
code including macros to __ASM_FORM().

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: x86@kernel.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: xen-devel@lists.xenproject.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/156777562873.25081.2288083344657460959.stgit@devnote2
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -7,9 +7,11 @@
 # define __ASM_FORM_RAW(x)     x
 # define __ASM_FORM_COMMA(x) x,
 #else
-# define __ASM_FORM(x)	" " #x " "
-# define __ASM_FORM_RAW(x)     #x
-# define __ASM_FORM_COMMA(x) " " #x ","
+#include <linux/stringify.h>
+
+# define __ASM_FORM(x)	" " __stringify(x) " "
+# define __ASM_FORM_RAW(x)     __stringify(x)
+# define __ASM_FORM_COMMA(x) " " __stringify(x) ","
 #endif
 
 #ifndef __x86_64__


