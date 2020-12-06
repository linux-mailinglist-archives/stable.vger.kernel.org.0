Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2542D022C
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgLFJKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:10:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57322 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgLFJKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 04:10:14 -0500
Date:   Sun, 06 Dec 2020 09:09:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607245771;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7NZzFHvvG3Z44Zmp07YaDC+CpeUesGmzpFQ7cGNXwMA=;
        b=Jzqj1AL0I3o5DAgai/EFxT+42mU3dNHtLqDzOfetedseeEr7VEdixGWPxCjCDAlVK5WtoO
        NHO9RIqBld9XAgF2vwy1mNp7XPmN4ZZwyVWa2la1RthG461v3JSYzHCW28LEpNi3toGGPx
        atwcIf160Ki5w0eWJcvGY9tT7emUDF283+v44gYGlEGlgER1oMq987nbdnazeP0yuY09nY
        KZL8xhsJyIM/hhNNtPu6bDMhjUR/5QTHwlr/6/c+OkMXeEA6UK9bbvCOqEEjkLdiG3yVpx
        i96NvEJ7ZbJ9d1UGtk5F8hv09d2ioYVVG7ghmPiYPng9c6gf0ThGM+VGe5DBBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607245771;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7NZzFHvvG3Z44Zmp07YaDC+CpeUesGmzpFQ7cGNXwMA=;
        b=3r++y7WkEsHYKdLsY8zkmZCiD0MXAnHijoPCbAcj1O0Awl1ca97fquFj/KNY6u1hA3yb/r
        roIgVueEiCVpFzCw==
From:   "tip-bot2 for Masami Hiramatsu" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/insn-eval: Use new for_each_insn_prefix() macro
 to loop over prefixes bytes
Cc:     syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <160697104969.3146288.16329307586428270032.stgit@devnote2>
References: <160697104969.3146288.16329307586428270032.stgit@devnote2>
MIME-Version: 1.0
Message-ID: <160724577056.3364.12183431793717178640.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     12cb908a11b2544b5f53e9af856e6b6a90ed5533
Gitweb:        https://git.kernel.org/tip/12cb908a11b2544b5f53e9af856e6b6a90ed5533
Author:        Masami Hiramatsu <mhiramat@kernel.org>
AuthorDate:    Thu, 03 Dec 2020 13:50:50 +09:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sun, 06 Dec 2020 10:03:08 +01:00

x86/insn-eval: Use new for_each_insn_prefix() macro to loop over prefixes bytes

Since insn.prefixes.nbytes can be bigger than the size of
insn.prefixes.bytes[] when a prefix is repeated, the proper check must
be

  insn.prefixes.bytes[i] != 0 and i < 4

instead of using insn.prefixes.nbytes. Use the new
for_each_insn_prefix() macro which does it correctly.

Debugged by Kees Cook <keescook@chromium.org>.

 [ bp: Massage commit message. ]

Fixes: 32d0b95300db ("x86/insn-eval: Add utility functions to get segment selector")
Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/160697104969.3146288.16329307586428270032.stgit@devnote2
---
 arch/x86/lib/insn-eval.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 58f7fb9..4229950 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -63,13 +63,12 @@ static bool is_string_insn(struct insn *insn)
  */
 bool insn_has_rep_prefix(struct insn *insn)
 {
+	insn_byte_t p;
 	int i;
 
 	insn_get_prefixes(insn);
 
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
-		insn_byte_t p = insn->prefixes.bytes[i];
-
+	for_each_insn_prefix(insn, i, p) {
 		if (p == 0xf2 || p == 0xf3)
 			return true;
 	}
@@ -95,14 +94,15 @@ static int get_seg_reg_override_idx(struct insn *insn)
 {
 	int idx = INAT_SEG_REG_DEFAULT;
 	int num_overrides = 0, i;
+	insn_byte_t p;
 
 	insn_get_prefixes(insn);
 
 	/* Look for any segment override prefixes. */
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
+	for_each_insn_prefix(insn, i, p) {
 		insn_attr_t attr;
 
-		attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
+		attr = inat_get_opcode_attribute(p);
 		switch (attr) {
 		case INAT_MAKE_PREFIX(INAT_PFX_CS):
 			idx = INAT_SEG_REG_CS;
