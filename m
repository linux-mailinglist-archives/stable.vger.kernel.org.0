Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9246357EE51
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbiGWKKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239415AbiGWKJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ACACBD35;
        Sat, 23 Jul 2022 03:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4D1A611BD;
        Sat, 23 Jul 2022 10:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2717C341C0;
        Sat, 23 Jul 2022 10:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570565;
        bh=UJnJ0k+B5Cwy8yaML0Wp60Wf0/bRoEx/BajCYGRGqcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=au7I7DGM62262qjhugNmz8baT9jTIjM2Ifh7PoxJyc3eOol0epijW/OUIuD4OZKe2
         RbIqVLqKMEir5kLQgkkIpLwA0Uj13FnQyzIkwLopm8hJpM0Et46FI5qYTFR8G2NS09
         GNSHYRdTeFk8PVIH1FqwFyfOHE9pkeIz19hTzSmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 130/148] x86/static_call: Serialize __static_call_fixup() properly
Date:   Sat, 23 Jul 2022 11:55:42 +0200
Message-Id: <20220723095300.761581244@linuxfoundation.org>
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
@@ -20,7 +20,8 @@ static const u8 tramp_ud[] = { 0x0f, 0xb
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 
-static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
+static void __ref __static_call_transform(void *insn, enum insn_type type,
+					  void *func, bool modinit)
 {
 	int size = CALL_INSN_SIZE;
 	const void *code;
@@ -49,7 +50,7 @@ static void __ref __static_call_transfor
 	if (memcmp(insn, code, size) == 0)
 		return;
 
-	if (unlikely(system_state == SYSTEM_BOOTING))
+	if (system_state == SYSTEM_BOOTING || modinit)
 		return text_poke_early(insn, code, size);
 
 	text_poke_bp(insn, code, size, NULL);
@@ -96,12 +97,12 @@ void arch_static_call_transform(void *si
 
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
@@ -127,8 +128,10 @@ bool __static_call_fixup(void *tramp, u8
 		return false;
 	}
 
+	mutex_lock(&text_mutex);
 	if (op == RET_INSN_OPCODE || dest == &__x86_return_thunk)
-		__static_call_transform(tramp, RET, NULL);
+		__static_call_transform(tramp, RET, NULL, true);
+	mutex_unlock(&text_mutex);
 
 	return true;
 }


