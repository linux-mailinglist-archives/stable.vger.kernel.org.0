Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1515F31144A
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhBEWDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232791AbhBEOyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 116B06506D;
        Fri,  5 Feb 2021 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534377;
        bh=G5P/XiJ/r0aAfV8EecjWAkw3cTrOQVR/Q/FuYaaP4js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuOp8HQvzK/lUokosX+/jKpYhQphCZj6fLsUmXlkFkGXmbqksNxLUnz4XstbzbTQz
         vmtnc9Zj87qk86QAOKuZznCZXNj4x3zX/uOmixidNNscTFfNFG5qR9QEKG9T+Wffgc
         LFTfzu9Qs86ZqhaG6swsSGRHs/VghAf7TeLsqQzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/32] objtool: Dont fail on missing symbol table
Date:   Fri,  5 Feb 2021 15:07:45 +0100
Message-Id: <20210205140653.619579792@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
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
index edba4745f25a9..693d740107a8b 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -214,8 +214,11 @@ static int read_symbols(struct elf *elf)
 
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



