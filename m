Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCD43C48FF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhGLGlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238230AbhGLGkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C27610CC;
        Mon, 12 Jul 2021 06:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071793;
        bh=RCHGY0c7RhcBv2l7xAuERXhf02mGxCiIEyM9qidHIqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJ2Fi94dSKnMXNLMATLFXhywrCcWrccBGIQFTBLRYU28puJVailE9eLXM0lN9Cth8
         V42INkbHpuB4tInYHI+257azvbTS0feQNKP+q9q6UjC6hv+vfQW+5kbsvSj8YQPuc7
         xLX+v2sKrKTdIIcffLm65ADVMiATp2x6v/0KdN1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/593] kbuild: Fix objtool dependency for OBJECT_FILES_NON_STANDARD_<obj> := n
Date:   Mon, 12 Jul 2021 08:06:22 +0200
Message-Id: <20210712060907.352266759@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 8852c552402979508fdc395ae07aa8761aa46045 ]

"OBJECT_FILES_NON_STANDARD_vma.o := n" has a dependency bug.  When
objtool source is updated, the affected object doesn't get re-analyzed
by objtool.

Peter's new variable-sized jump label feature relies on objtool
rewriting the object file.  Otherwise the system can fail to boot.  That
effectively upgrades this minor dependency issue to a major bug.

The problem is that variables in prerequisites are expanded early,
during the read-in phase.  The '$(objtool_dep)' variable indirectly uses
'$@', which isn't yet available when the target prerequisites are
evaluated.

Use '.SECONDEXPANSION:' which causes '$(objtool_dep)' to be expanded in
a later phase, after the target-specific '$@' variable has been defined.

Fixes: b9ab5ebb14ec ("objtool: Add CONFIG_STACK_VALIDATION option")
Fixes: ab3257042c26 ("jump_label, x86: Allow short NOPs")
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4c058f12dd73..8bd4e673383f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -275,7 +275,8 @@ define rule_as_o_S
 endef
 
 # Built-in and composite module parts
-$(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
+.SECONDEXPANSION:
+$(obj)/%.o: $(src)/%.c $(recordmcount_source) $$(objtool_dep) FORCE
 	$(call if_changed_rule,cc_o_c)
 	$(call cmd,force_checksrc)
 
@@ -356,7 +357,7 @@ cmd_modversions_S =								\
 	fi
 endif
 
-$(obj)/%.o: $(src)/%.S $(objtool_dep) FORCE
+$(obj)/%.o: $(src)/%.S $$(objtool_dep) FORCE
 	$(call if_changed_rule,as_o_S)
 
 targets += $(filter-out $(subdir-builtin), $(real-obj-y))
-- 
2.30.2



