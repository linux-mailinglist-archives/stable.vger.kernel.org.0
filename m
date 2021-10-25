Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F6D43A329
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbhJYT4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237988AbhJYTxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C906611C0;
        Mon, 25 Oct 2021 19:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191047;
        bh=iZsZt9Wfa6f0L6Q0b7KVcdTKMTJAy+npREB4ivJqzbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTrL2S9R165l6fzMCyUkLTyUe6zVWUgMZHTGoWNVCN3wySLChmjoRu4Cp4zIVEptT
         DvTjxkdrB1amQWui9iufF1ehq/kS2BC/bRZ5VivuBzu99yJnL2U8wPj6EeqjanLxYq
         AyxEN2qaOit60NqHZEuFHY2peYXdGR+u60FXDCwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Forney <mforney@mforney.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 132/169] objtool: Check for gelf_update_rel[a] failures
Date:   Mon, 25 Oct 2021 21:15:13 +0200
Message-Id: <20211025191034.435499528@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



