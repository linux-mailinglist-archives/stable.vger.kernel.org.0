Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF96359B37
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhDIKHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234334AbhDIKF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C010961366;
        Fri,  9 Apr 2021 10:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962528;
        bh=AV+j3BJJ9gQwFzCyaoQzsgxuO8rJZQ5JkqDqlP6FvKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK0qgOkd5342XNgwVV6IwR/he2keyO4YBq6Ykb0E3Bj9Y9fRZbjUfz8TTchHLIotk
         JJZ3WwKAYTisJLIiKpLiR/LZ8hG2LyqVKaqG04AZ9KbNClc/03NdTsqtPW2a3FPk1v
         7C/pGhQyLFaidJv5H+3QOY4sAgKSXyM0UJ6CERCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 40/45] kbuild: Add resolve_btfids clean to root clean target
Date:   Fri,  9 Apr 2021 11:54:06 +0200
Message-Id: <20210409095306.709355204@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 50d3a3f81689586697a38cd60070181ebe626ad9 ]

The resolve_btfids tool is used during the kernel build,
so we should clean it on kernel's make clean.

Invoking the the resolve_btfids clean as part of root
'make clean'.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20210205124020.683286-5-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1e31504aab61..a135a7b9d265 100644
--- a/Makefile
+++ b/Makefile
@@ -1082,6 +1082,11 @@ ifdef CONFIG_STACK_VALIDATION
   endif
 endif
 
+PHONY += resolve_btfids_clean
+
+resolve_btfids_clean:
+	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
+
 ifdef CONFIG_BPF
 ifdef CONFIG_DEBUG_INFO_BTF
   ifeq ($(has_libelf),1)
@@ -1499,7 +1504,7 @@ vmlinuxclean:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
 
-clean: archclean vmlinuxclean
+clean: archclean vmlinuxclean resolve_btfids_clean
 
 # mrproper - Delete all generated files, including .config
 #
-- 
2.30.2



