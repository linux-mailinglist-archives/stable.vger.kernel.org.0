Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C9857EDC5
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbiGWKCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237723AbiGWKCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:02:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7288A66AE5;
        Sat, 23 Jul 2022 02:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65737611BD;
        Sat, 23 Jul 2022 09:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2E6C341C0;
        Sat, 23 Jul 2022 09:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570326;
        bh=Z9v+W6Ypo/TtsuKDyVQ7GeOlltbq63xMAp1hYKg1CZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B13Slh3MIH/hbHJG/7JBDCPR8FKD1HhpfF1Z0JaNOl3/t3LDXfvqioPcwOjbQvoPc
         nfbHoiivnlcuo+l+p3YcNkYICY5JhxgFgzH/z8DhmAAXhMgip0j3gp7MUiUBFRr/Gb
         1oh3gdkT+OcdG8M4dRxxNLti4jHqcWbsRDjio1XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 058/148] x86/alternative: Add debug prints to apply_retpolines()
Date:   Sat, 23 Jul 2022 11:54:30 +0200
Message-Id: <20220723095240.500142143@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit d4b5a5c993009ffeb5febe3b701da3faab6adb96 upstream.

Make sure we can see the text changes when booting with
'debug-alternative'.

Example output:

 [ ] SMP alternatives: retpoline at: __traceiter_initcall_level+0x1f/0x30 (ffffffff8100066f) len: 5 to: __x86_indirect_thunk_rax+0x0/0x20
 [ ] SMP alternatives: ffffffff82603e58: [2:5) optimized NOPs: ff d0 0f 1f 00
 [ ] SMP alternatives: ffffffff8100066f: orig: e8 cc 30 00 01
 [ ] SMP alternatives: ffffffff8100066f: repl: ff d0 0f 1f 00

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.422273830@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -647,9 +647,15 @@ void __init_or_module noinline apply_ret
 			continue;
 		}
 
+		DPRINTK("retpoline at: %pS (%px) len: %d to: %pS",
+			addr, addr, insn.length,
+			addr + insn.length + insn.immediate.value);
+
 		len = patch_retpoline(addr, &insn, bytes);
 		if (len == insn.length) {
 			optimize_nops(bytes, len);
+			DUMP_BYTES(((u8*)addr),  len, "%px: orig: ", addr);
+			DUMP_BYTES(((u8*)bytes), len, "%px: repl: ", addr);
 			text_poke_early(addr, bytes, len);
 		}
 	}


