Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C296D305109
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbhA0Ejj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:39:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392134AbhA0B3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 20:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611710853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dU8QX/h/vjBjnhU5t98HRai2UnS3oSTBehfr01OHUMU=;
        b=dbgARIllyz5ed2TZDvZN9PUy2Flj6UN4VYCJACztPuA9+GblkDiGXuOguNWiMZ629uQsNq
        v4hHYQSMbLI/j3PPy9byu1k1OFbNyKrZy9DipOW8Lj0jsxqCCvDtin/IVluqQiO0zSO8tR
        QDmTagAlJtP8k4aYpZnP8SH7oxucjXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-umPzXiyZPsaWdMsRRUQQvw-1; Tue, 26 Jan 2021 20:27:30 -0500
X-MC-Unique: umPzXiyZPsaWdMsRRUQQvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B21AE190A7A0;
        Wed, 27 Jan 2021 01:27:29 +0000 (UTC)
Received: from treble.redhat.com (ovpn-120-118.rdu2.redhat.com [10.10.120.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20EB15D9D5;
        Wed, 27 Jan 2021 01:27:29 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     stable@vger.kernel.org
Cc:     fengxiangjun <hifxj@yeah.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 5.10-stable] objtool: Don't fail on missing symbol table
Date:   Tue, 26 Jan 2021 19:27:04 -0600
Message-Id: <7e6b9d198e38edf8760ae730a0e5092e6e492924.1611710561.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 1d489151e9f9d1647110277ff77282fe4d96d09b upstream.

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
---

This fixes a build break caused by the most recent version of binutils
(2.36).

 tools/objtool/elf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 4e1d7460574b..9452cfb01ef1 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -354,8 +354,11 @@ static int read_symbols(struct elf *elf)
 
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
 
 	symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
-- 
2.29.2

