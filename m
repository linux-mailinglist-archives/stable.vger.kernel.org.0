Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06626E674C
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbfJ0VTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbfJ0VTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:36 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A798920717;
        Sun, 27 Oct 2019 21:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211175;
        bh=RI9MPlO+lvnuqKMcP+8ukZ2/t6jJxYoBzXCL0CCGbsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9S3hPBSMGYdrun1nTVqFlmz0d2v6EN9WDzaDzQ3jQ7kOxg04dLexgNjRULGlei+k
         Pzw9nEMXzFQ/NcDTEAyXr/tPru4LtCUHiV/ZUItLMp+IGbaUtCpVvaA2xKcLwMwslB
         IaqvZa9JL9zPW/X9uULYe4fvVV8DXsnELq4h6Mn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Michal Hocko <mhocko@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 058/197] elf: dont use MAP_FIXED_NOREPLACE for elf executable mappings
Date:   Sun, 27 Oct 2019 21:59:36 +0100
Message-Id: <20191027203354.803599528@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit b212921b13bda088a004328457c5c21458262fe2 ]

In commit 4ed28639519c ("fs, elf: drop MAP_FIXED usage from elf_map") we
changed elf to use MAP_FIXED_NOREPLACE instead of MAP_FIXED for the
executable mappings.

Then, people reported that it broke some binaries that had overlapping
segments from the same file, and commit ad55eac74f20 ("elf: enforce
MAP_FIXED on overlaying elf segments") re-instated MAP_FIXED for some
overlaying elf segment cases.  But only some - despite the summary line
of that commit, it only did it when it also does a temporary brk vma for
one obvious overlapping case.

Now Russell King reports another overlapping case with old 32-bit x86
binaries, which doesn't trigger that limited case.  End result: we had
better just drop MAP_FIXED_NOREPLACE entirely, and go back to MAP_FIXED.

Yes, it's a sign of old binaries generated with old tool-chains, but we
do pride ourselves on not breaking existing setups.

This still leaves MAP_FIXED_NOREPLACE in place for the load_elf_interp()
and the old load_elf_library() use-cases, because nobody has reported
breakage for those. Yet.

Note that in all the cases seen so far, the overlapping elf sections
seem to be just re-mapping of the same executable with different section
attributes.  We could possibly introduce a new MAP_FIXED_NOFILECHANGE
flag or similar, which acts like NOREPLACE, but allows just remapping
the same executable file using different protection flags.

It's not clear that would make a huge difference to anything, but if
people really hate that "elf remaps over previous maps" behavior, maybe
at least a more limited form of remapping would alleviate some concerns.

Alternatively, we should take a look at our elf_map() logic to see if we
end up not mapping things properly the first time.

In the meantime, this is the minimal "don't do that then" patch while
people hopefully think about it more.

Reported-by: Russell King <linux@armlinux.org.uk>
Fixes: 4ed28639519c ("fs, elf: drop MAP_FIXED usage from elf_map")
Fixes: ad55eac74f20 ("elf: enforce  MAP_FIXED on overlaying elf segments")
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f131651502b8a..c62903290f3a5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -899,7 +899,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
-		int elf_prot, elf_flags, elf_fixed = MAP_FIXED_NOREPLACE;
+		int elf_prot, elf_flags;
 		unsigned long k, vaddr;
 		unsigned long total_size = 0;
 
@@ -931,13 +931,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 					 */
 				}
 			}
-
-			/*
-			 * Some binaries have overlapping elf segments and then
-			 * we have to forcefully map over an existing mapping
-			 * e.g. over this newly established brk mapping.
-			 */
-			elf_fixed = MAP_FIXED;
 		}
 
 		elf_prot = make_prot(elf_ppnt->p_flags);
@@ -950,7 +943,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		 * the ET_DYN load_addr calculations, proceed normally.
 		 */
 		if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
-			elf_flags |= elf_fixed;
+			elf_flags |= MAP_FIXED;
 		} else if (loc->elf_ex.e_type == ET_DYN) {
 			/*
 			 * This logic is run once for the first LOAD Program
@@ -986,7 +979,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
-				elf_flags |= elf_fixed;
+				elf_flags |= MAP_FIXED;
 			} else
 				load_bias = 0;
 
-- 
2.20.1



