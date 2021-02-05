Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F51311469
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhBEWFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232941AbhBEO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41364650B7;
        Fri,  5 Feb 2021 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534475;
        bh=C8ZbliidtWdLrQu2YqsKNvIB9f+KJX3XYeJa+/oUWqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZlCcYlznZ+cvXOJpS3/mzjJT5/oAJVVYgjF0iQLA6KYc0aU6uJMHpzZMcYG4D6Vz
         NKQ9AlYfKQIrzPO7+AscSzCxaVhD7Y5Zv3bb4bV2ksl3JgObpq4lF9bFmKwet+BUiC
         x/3H85EbdptlOSq6VCsZLz6zWDsk17bDJesJYbS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/15] objtool: Dont fail on missing symbol table
Date:   Fri,  5 Feb 2021 15:08:59 +0100
Message-Id: <20210205140650.308445732@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.733510103@linuxfoundation.org>
References: <20210205140649.733510103@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 1d489151e9f9d1647110277ff77282fe4d96d09b ]

Thanks to a recent binutils change which doesn't generate unused
symbols, it's now possible for thunk_64.o be completely empty without
CONFIG_PREEMPTION: no text, no data, no symbols.

We could edit the Makefile to only build that file when
CONFIG_PREEMPTION is enabled, but that will likely create confusion
if/when the thunks end up getting used by some other code again.

Just ignore it and move on.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1254
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d089c711355a9..fa269622a974e 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -226,8 +226,11 @@ static int read_symbols(struct elf *elf)
 
 	symtab = find_section_by_name(elf, ".symtab");
 	if (!symtab) {
-		WARN("missing symbol table");
-		return -1;
+		/*
+		 * A missing symbol table is actually possible if it's an empty
+		 * .o file.  This can happen for thunk_64.o.
+		 */
+		return 0;
 	}
 
 	symbols_nr = symtab->sh.sh_size / symtab->sh.sh_entsize;
-- 
2.27.0



