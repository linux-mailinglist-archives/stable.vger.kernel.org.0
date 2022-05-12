Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9488C524F0E
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354845AbiELN6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354833AbiELN6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:58:33 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62881EEE1B;
        Thu, 12 May 2022 06:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1652363911; x=1683899911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fXdsCza0w8qNDoFrKMYkMnUAwI+hskYjRxqBpTNbyyY=;
  b=T1LDzVLXLuacWaHxogaYGICrW1r2tquL/p/GrpOGRpHF89nGsI+Sg7fm
   RLytGpFR1FKfC2gxRe4WJLjMThdpnhQ1uLcN5Iu6p4aiN4h829IHUvpE7
   PH7pkWUdw3729vE+kW8/XTp5VMDT3UDuQXOcl/9I82iXLS6cZJL0OjTu4
   s=;
X-IronPort-AV: E=Sophos;i="5.91,220,1647302400"; 
   d="scan'208";a="202425735"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-ff3df2fe.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 12 May 2022 13:58:15 +0000
Received: from EX13D08EUC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-ff3df2fe.us-west-2.amazon.com (Postfix) with ESMTPS id BF6FC41E0E;
        Thu, 12 May 2022 13:58:06 +0000 (UTC)
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08EUC002.ant.amazon.com (10.43.164.124) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 12 May 2022 13:58:04 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Thu, 12 May 2022 13:58:04 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id E90A841131; Thu, 12 May 2022 13:58:03 +0000 (UTC)
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
Subject: [PATCH 4/4] x86: kprobes: Prohibit probing on instruction which has emulate prefix
Date:   Thu, 12 May 2022 13:56:51 +0000
Message-ID: <20220512135654.119791-5-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220512135654.119791-1-mheyne@amazon.de>
References: <20220512135654.119791-1-mheyne@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 004e8dce9c5595697951f7cd0e9f66b35c92265e upstream

Prohibit probing on instruction which has XEN_EMULATE_PREFIX
or KVM's emulate prefix. Since that prefix is a marker for Xen
and KVM, if we modify the marker by kprobe's int3, that doesn't
work as expected.

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
Link: https://lkml.kernel.org/r/156777566048.25081.6296162369492175325.stgit@devnote2
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Cc: stable@vger.kernel.org # 5.4.x
---
 arch/x86/kernel/kprobes/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index c205d77d57da..3700dc94847c 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -358,6 +358,10 @@ int __copy_instruction(u8 *dest, u8 *src, u8 *real, struct insn *insn)
 	kernel_insn_init(insn, dest, MAX_INSN_SIZE);
 	insn_get_length(insn);
 
+	/* We can not probe force emulate prefixed instruction */
+	if (insn_has_emulate_prefix(insn))
+		return 0;
+
 	/* Another subsystem puts a breakpoint, failed to recover */
 	if (insn->opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
 		return 0;
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



