Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613414290E8
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbhJKOOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243411AbhJKOLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7578E61105;
        Mon, 11 Oct 2021 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960985;
        bh=DhbK6jwRhGcJoNCZCiAJuMgy8jFuWH9LvcIvAtDFR3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs4cqHYqDm5QpieCCslfA5ZzLMfk/QTYKf2sLHDTwxtrvW7R4yamzk6cUdMJP2VDq
         ZZ54BglgHQrfX2YFIzDtTmE2awvdyGZN3SbsWxVarXMe0n1isz5KKSo2q3ncKIiUAB
         GiiRgl+K4XcOHM605o+Fm45Rl+es/j7kYy4H/wTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 132/151] objtool: Make .altinstructions section entry size consistent
Date:   Mon, 11 Oct 2021 15:46:44 +0200
Message-Id: <20211011134522.069620035@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit dc02368164bd0ec603e3f5b3dd8252744a667b8a ]

Commit e31694e0a7a7 ("objtool: Don't make .altinstructions writable")
aligned objtool-created and kernel-created .altinstructions section
flags, but there remains a minor discrepency in their use of a section
entry size: objtool sets one while the kernel build does not.

While sh_entsize of sizeof(struct alt_instr) seems intuitive, this small
deviation can cause failures with external tooling (kpatch-build).

Fix this by creating new .altinstructions sections with sh_entsize of 0
and then later updating sec->sh_size as alternatives are added to the
section.  An added benefit is avoiding the data descriptor and buffer
created by elf_create_section(), but previously unused by
elf_add_alternative().

Fixes: 9bc0bb50727c ("objtool/x86: Rewrite retpoline thunk calls")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20210822225037.54620-2-joe.lawrence@redhat.com
Cc: Andy Lavr <andy.lavr@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index bc821056aba9..0893436cc09f 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -684,7 +684,7 @@ static int elf_add_alternative(struct elf *elf,
 	sec = find_section_by_name(elf, ".altinstructions");
 	if (!sec) {
 		sec = elf_create_section(elf, ".altinstructions",
-					 SHF_ALLOC, size, 0);
+					 SHF_ALLOC, 0, 0);
 
 		if (!sec) {
 			WARN_ELF("elf_create_section");
-- 
2.33.0



