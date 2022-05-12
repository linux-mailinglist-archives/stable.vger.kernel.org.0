Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DFA524EFF
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354815AbiELN6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354805AbiELN6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:58:09 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3861E0584;
        Thu, 12 May 2022 06:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1652363889; x=1683899889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TwU6CtF1V9/2Y57AY/B4As4rfmtIlL8LhHI2uYJkLIs=;
  b=hU1FQ2GESOUzT3kx9A0eSnDbmLrgdyNRIv2iYOGL90OR9SsSDPe/xajw
   Dslzd8Oj4ElADdqlKZFoY4WR0mRbRycA+lBvOQ4F9PWbx9QbYp3GKf08V
   9U/ZDIVd7MzkFI6pcADarLQo8fLCjeq7Vsqb8xc6VvVMrTs3hAUscu8XV
   A=;
X-IronPort-AV: E=Sophos;i="5.91,220,1647302400"; 
   d="scan'208";a="201008279"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 May 2022 13:57:52 +0000
Received: from EX13D08EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 5307941DA5;
        Thu, 12 May 2022 13:57:50 +0000 (UTC)
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08EUC001.ant.amazon.com (10.43.164.184) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 12 May 2022 13:57:48 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Thu, 12 May 2022 13:57:48 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id 01C5341131; Thu, 12 May 2022 13:57:48 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
To:     <stable@vger.kernel.org>
CC:     Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>, <x86@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        <xen-devel@lists.xenproject.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Maximilian Heyne <mheyne@amazon.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 1/4] x86/asm: Allow to pass macros to __ASM_FORM()
Date:   Thu, 12 May 2022 13:56:48 +0000
Message-ID: <20220512135654.119791-2-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220512135654.119791-1-mheyne@amazon.de>
References: <20220512135654.119791-1-mheyne@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit f7919fd943abf0c77aed4441ea9897a323d132f5 upstream

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
Cc: stable@vger.kernel.org # 5.4.x
---
 arch/x86/include/asm/asm.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 3ff577c0b102..1b563f9167ea 100644
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
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



