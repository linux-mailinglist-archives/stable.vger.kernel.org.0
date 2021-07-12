Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420D43C454A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhGLGZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234646AbhGLGX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B8C161152;
        Mon, 12 Jul 2021 06:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070804;
        bh=39LKZJUB+Tgb98s9dzK/Pe8GjXLJrSAZhffOSDlpeuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGc/tPp87+AF12WYfmN43U0BJWrFc/yWQWsZ+IjxXTC+lfX/9MlpE7rjW3GEzn/u3
         gD83exV7kp4xnUz+mgZt+fpQ2el6PmgFsk4CGgu72lg6pah+NdXJpmZC+g9g2ZA5xU
         jt2XzcDeIw+u8NI0Svw00w08cI/ytHgpGlFP16FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/348] kbuild: run the checker after the compiler
Date:   Mon, 12 Jul 2021 08:08:50 +0200
Message-Id: <20210712060720.455882445@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

[ Upstream commit 0c33f125732d0d33392ba6774d85469d565d3496 ]

Since the pre-git time the checker is run first, before the compiler.
But if the source file contains some syntax error, the warnings from
the compiler are more useful than those from sparse (and other
checker most probably too).

So move the 'check' command to run after the compiler.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9c689d011bce..03df22412f86 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -240,9 +240,9 @@ undefined_syms = $(NM) $< | $(AWK) '$$1 == "U" { printf("%s%s", x++ ? " " : "",
 endif
 
 define rule_cc_o_c
-	$(call cmd,checksrc)
 	$(call cmd_and_fixdep,cc_o_c)
 	$(call cmd,gen_ksymdeps)
+	$(call cmd,checksrc)
 	$(call cmd,checkdoc)
 	$(call cmd,objtool)
 	$(call cmd,modversions_c)
@@ -258,8 +258,8 @@ endef
 
 # Built-in and composite module parts
 $(obj)/%.o: $(src)/%.c $(recordmcount_source) $(objtool_dep) FORCE
-	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 cmd_mod = { \
 	echo $(if $($*-objs)$($*-y)$($*-m), $(addprefix $(obj)/, $($*-objs) $($*-y) $($*-m)), $(@:.mod=.o)); \
-- 
2.30.2



