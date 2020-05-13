Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7311D0B62
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgEMI7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 04:59:54 -0400
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:40382 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgEMI7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 04:59:54 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 04D8xeUK011949; Wed, 13 May 2020 17:59:40 +0900
X-Iguazu-Qid: 34trvY1fFe4gKchsTT
X-Iguazu-QSIG: v=2; s=0; t=1589360380; q=34trvY1fFe4gKchsTT; m=YGsCUDiFF0rekN/dioa5Vn1o9+lwg/r/hxhrlg2wrRU=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id 04D8xcVf028225;
        Wed, 13 May 2020 17:59:38 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 04D8xc6T006206;
        Wed, 13 May 2020 17:59:38 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 04D8xbIY024974;
        Wed, 13 May 2020 17:59:37 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Kees Cook <keescook@chromium.org>,
        Richard Kojedzinszky <richard@kojedz.in>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4, 4.9] binfmt_elf: Do not move brk for INTERP-less ET_EXEC
Date:   Wed, 13 May 2020 17:59:32 +0900
X-TSB-HOP: ON
Message-Id: <20200513085932.920902-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 7be3cb019db1cbd5fd5ffe6d64a23fefa4b6f229 upstream.

When brk was moved for binaries without an interpreter, it should have
been limited to ET_DYN only. In other words, the special case was an
ET_DYN that lacks an INTERP, not just an executable that lacks INTERP.
The bug manifested for giant static executables, where the brk would end
up in the middle of the text area on 32-bit architectures.

Reported-and-tested-by: Richard Kojedzinszky <richard@kojedz.in>
Fixes: bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 fs/binfmt_elf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index a6857e9bd4460..164e5fedd7b6a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1104,7 +1104,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		 * (since it grows up, and may collide early with the stack
 		 * growing down), and into the unused ELF_ET_DYN_BASE region.
 		 */
-		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) && !interpreter)
+		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
+		    loc->elf_ex.e_type == ET_DYN && !interpreter)
 			current->mm->brk = current->mm->start_brk =
 				ELF_ET_DYN_BASE;
 
-- 
2.26.0

