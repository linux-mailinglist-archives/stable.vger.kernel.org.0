Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CB83C4D24
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240510AbhGLHME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244186AbhGLHK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AED52613D7;
        Mon, 12 Jul 2021 07:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073627;
        bh=kDZcUNlg8Zo7TUb2wJFOiS67BH/jS2vB68YPXGZ4zbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTIwR89y6D23htOvfswrlL5fB/62377u3P4KUb2DFHiab07UDjtkmuGB44GX9hT6V
         SzgoajuBNBoir8+AJOYqz/vhpAsXTNv+JlCip3OVNM3VnX1PfzDnRGuYNj35zAafyv
         3uD1ZDViO5j7KkPPiPJ8UgR9wzJRxx/uNpb5haAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 262/700] kbuild: Fix objtool dependency for OBJECT_FILES_NON_STANDARD_<obj> := n
Date:   Mon, 12 Jul 2021 08:05:45 +0200
Message-Id: <20210712061004.052317180@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 1b6094a13034..73701d637ed5 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -267,7 +267,8 @@ define rule_as_o_S
 endef
 
 # Built-in and composite module parts
-$(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
+.SECONDEXPANSION:
+$(obj)/%.o: $(src)/%.c $(recordmcount_source) $$(objtool_dep) FORCE
 	$(call if_changed_rule,cc_o_c)
 	$(call cmd,force_checksrc)
 
@@ -348,7 +349,7 @@ cmd_modversions_S =								\
 	fi
 endif
 
-$(obj)/%.o: $(src)/%.S $(objtool_dep) FORCE
+$(obj)/%.o: $(src)/%.S $$(objtool_dep) FORCE
 	$(call if_changed_rule,as_o_S)
 
 targets += $(filter-out $(subdir-builtin), $(real-obj-y))
-- 
2.30.2



