Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB572D600F
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391315AbgLJOka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391306AbgLJOk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:26 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.9 75/75] x86/insn-eval: Use new for_each_insn_prefix() macro to loop over prefixes bytes
Date:   Thu, 10 Dec 2020 15:27:40 +0100
Message-Id: <20201210142609.713112236@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 12cb908a11b2544b5f53e9af856e6b6a90ed5533 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/insn-eval.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -70,14 +70,15 @@ static int get_seg_reg_override_idx(stru
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


