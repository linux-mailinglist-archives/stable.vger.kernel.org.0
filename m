Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0794356EA
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhJUAXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231531AbhJUAXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2453C6128E;
        Thu, 21 Oct 2021 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775658;
        bh=iZsZt9Wfa6f0L6Q0b7KVcdTKMTJAy+npREB4ivJqzbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBQCK6gDL+skR08SwvheHnyzUKahM/d0fks38d2gcmPBgIiqzHkiiNS+yTyE7TTtW
         EBDxjwESUGScMlWdo7hqsCK6P9MBHv1w7lOfBSmOsEJcGWXjxrr5Oo1R/pgHDUe1ds
         8Hpkbliiz9SB8vwpvGEO5v7W4C+oFiNQnojDaXy1GA5EnkMpHecsYKeOCsuvzBcfq2
         1fsG7PXMJ0/7iGtPt/4hBhS/jEggYNYxE0bW4fUZyYhqkI+j40bUEZBFDckgYAXZMM
         KxSdcZ5L7TxRs3mkwZjgiWfk8IpPWVRQiXr1CImVPaQTMyHTaUHvTW61eFnMG/7skK
         p+WEKXFEQlM+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Forney <mforney@mforney.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org
Subject: [PATCH AUTOSEL 5.14 08/26] objtool: Check for gelf_update_rel[a] failures
Date:   Wed, 20 Oct 2021 20:20:05 -0400
Message-Id: <20211021002023.1128949-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Forney <mforney@mforney.org>

[ Upstream commit b46179d6bb3182c020f2bf9bb4df6ba5463b0495 ]

Otherwise, if these fail we end up with garbage data in the
.rela.orc_unwind_ip section, leading to errors like

  ld: fs/squashfs/namei.o: bad reloc symbol index (0x7f16 >= 0x12) for offset 0x7f16d5c82cc8 in section `.orc_unwind_ip'

Signed-off-by: Michael Forney <mforney@mforney.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20210509000103.11008-1-mforney@mforney.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 8676c7598728..6cf4c0f11906 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1003,7 +1003,10 @@ static int elf_rebuild_rel_reloc_section(struct section *sec, int nr)
 	list_for_each_entry(reloc, &sec->reloc_list, list) {
 		reloc->rel.r_offset = reloc->offset;
 		reloc->rel.r_info = GELF_R_INFO(reloc->sym->idx, reloc->type);
-		gelf_update_rel(sec->data, idx, &reloc->rel);
+		if (!gelf_update_rel(sec->data, idx, &reloc->rel)) {
+			WARN_ELF("gelf_update_rel");
+			return -1;
+		}
 		idx++;
 	}
 
@@ -1035,7 +1038,10 @@ static int elf_rebuild_rela_reloc_section(struct section *sec, int nr)
 		reloc->rela.r_offset = reloc->offset;
 		reloc->rela.r_addend = reloc->addend;
 		reloc->rela.r_info = GELF_R_INFO(reloc->sym->idx, reloc->type);
-		gelf_update_rela(sec->data, idx, &reloc->rela);
+		if (!gelf_update_rela(sec->data, idx, &reloc->rela)) {
+			WARN_ELF("gelf_update_rela");
+			return -1;
+		}
 		idx++;
 	}
 
-- 
2.33.0

