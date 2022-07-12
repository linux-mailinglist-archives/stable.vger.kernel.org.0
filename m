Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1DA57250B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiGLTHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbiGLTHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:07:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76985FB8F0;
        Tue, 12 Jul 2022 11:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2AD86149A;
        Tue, 12 Jul 2022 18:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEA0C3411C;
        Tue, 12 Jul 2022 18:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651871;
        bh=sO/NRT++o1GVJ2ZubOWRLCd5AukTe/ungHx3/aluXy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMSBg/upjTUYNgowMTS3eRPly58zf3TxI//bKZNRxxOCMJCP55UIhVoUPBiv/lrK5
         ihTPlGho9ZE55wPwMKBjy4w6F5ZG3R3+Q9UP+h6s+PpiHIF4kXubCFpfKdZvxLeg4m
         60WqgiudDwrieQXvo3TJSRW+iDM7vLNbaX2BTAjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 78/78] x86/static_call: Serialize __static_call_fixup() properly
Date:   Tue, 12 Jul 2022 20:39:48 +0200
Message-Id: <20220712183242.085202699@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit c27c753ea6fd1237f4f96abf8b623d7bab505513 upstream.

__static_call_fixup() invokes __static_call_transform() without holding
text_mutex, which causes lockdep to complain in text_poke_bp().

Adding the proper locking cures that, but as this is either used during
early boot or during module finalizing, it's not required to use
text_poke_bp(). Add an argument to __static_call_transform() which tells
it to use text_poke_early() for it.

Fixes: ee88d363d156 ("x86,static_call: Use alternative RET encoding")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/static_call.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -25,7 +25,8 @@ static const u8 xor5rax[] = { 0x2e, 0x2e
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 
-static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
+static void __ref __static_call_transform(void *insn, enum insn_type type,
+					  void *func, bool modinit)
 {
 	const void *emulate = NULL;
 	int size = CALL_INSN_SIZE;
@@ -60,7 +61,7 @@ static void __ref __static_call_transfor
 	if (memcmp(insn, code, size) == 0)
 		return;
 
-	if (unlikely(system_state == SYSTEM_BOOTING))
+	if (system_state == SYSTEM_BOOTING || modinit)
 		return text_poke_early(insn, code, size);
 
 	text_poke_bp(insn, code, size, emulate);
@@ -108,12 +109,12 @@ void arch_static_call_transform(void *si
 
 	if (tramp) {
 		__static_call_validate(tramp, true);
-		__static_call_transform(tramp, __sc_insn(!func, true), func);
+		__static_call_transform(tramp, __sc_insn(!func, true), func, false);
 	}
 
 	if (IS_ENABLED(CONFIG_HAVE_STATIC_CALL_INLINE) && site) {
 		__static_call_validate(site, tail);
-		__static_call_transform(site, __sc_insn(!func, tail), func);
+		__static_call_transform(site, __sc_insn(!func, tail), func, false);
 	}
 
 	mutex_unlock(&text_mutex);
@@ -139,8 +140,10 @@ bool __static_call_fixup(void *tramp, u8
 		return false;
 	}
 
+	mutex_lock(&text_mutex);
 	if (op == RET_INSN_OPCODE || dest == &__x86_return_thunk)
-		__static_call_transform(tramp, RET, NULL);
+		__static_call_transform(tramp, RET, NULL, true);
+	mutex_unlock(&text_mutex);
 
 	return true;
 }


