Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED883AF399
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 20:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhFUSC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233617AbhFUSAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EDAF60C41;
        Mon, 21 Jun 2021 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298081;
        bh=+6wiNLqqnTiDXKehP3jGCjGTfB/a5ux91Dp8LbOhIfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCeeC9xTJkhNKj47Mr+zBc1JDoEOVQuSx3Zzo0WNvTBF/vBKrgL86UE4R9HzxKU/e
         qR+1TLR/KNiyZD4FlyyGmiMAj578xhQc35PhbwLU+YsCNkMHPVei9Q0cZX3fuBjRrt
         iwRn9fnY6BBJoRiAM1W/VNRo4mwyRmgjWS/VbgZLJS8Oxr0cGSN8cqc1xZbluloI4G
         j1PfEuQK6YjrefWCbohBV75+PziPdX6ARMhQBXUrm71D0rLdyCB4XwmKTcXW1MSlOr
         Xr18UBAeX6wfHGC5eAd91vitA0Wc0oGGc0ZxOo0Dmlu46fB5cAJLxbe+qqtznYKOH7
         tv9zWFt9UkHQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 23/26] recordmcount: Correct st_shndx handling
Date:   Mon, 21 Jun 2021 13:53:56 -0400
Message-Id: <20210621175400.735800-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit fb780761e7bd9f2e94f5b9a296ead6b35b944206 ]

One should only use st_shndx when >SHN_UNDEF and <SHN_LORESERVE. When
SHN_XINDEX, then use .symtab_shndx. Otherwise use 0.

This handles the case: st_shndx >= SHN_LORESERVE && st_shndx != SHN_XINDEX.

Link: https://lore.kernel.org/lkml/20210607023839.26387-1-mark-pk.tsai@mediatek.com/
Link: https://lkml.kernel.org/r/20210616154126.2794-1-mark-pk.tsai@mediatek.com

Reported-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
[handle endianness of sym->st_shndx]
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/recordmcount.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index f9b19524da11..1e9baa5c4fc6 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -192,15 +192,20 @@ static unsigned int get_symindex(Elf_Sym const *sym, Elf32_Word const *symtab,
 				 Elf32_Word const *symtab_shndx)
 {
 	unsigned long offset;
+	unsigned short shndx = w2(sym->st_shndx);
 	int index;
 
-	if (sym->st_shndx != SHN_XINDEX)
-		return w2(sym->st_shndx);
+	if (shndx > SHN_UNDEF && shndx < SHN_LORESERVE)
+		return shndx;
 
-	offset = (unsigned long)sym - (unsigned long)symtab;
-	index = offset / sizeof(*sym);
+	if (shndx == SHN_XINDEX) {
+		offset = (unsigned long)sym - (unsigned long)symtab;
+		index = offset / sizeof(*sym);
 
-	return w(symtab_shndx[index]);
+		return w(symtab_shndx[index]);
+	}
+
+	return 0;
 }
 
 static unsigned int get_shnum(Elf_Ehdr const *ehdr, Elf_Shdr const *shdr0)
-- 
2.30.2

