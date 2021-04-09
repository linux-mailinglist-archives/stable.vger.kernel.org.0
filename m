Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A450A359AEE
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhDIKHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232897AbhDIKCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:02:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA0C061260;
        Fri,  9 Apr 2021 10:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962418;
        bh=dj5VacYFoiQnvunQeXBeyt0jxRmd1RVx1iUDaLJvhp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBs7o9EAoaMdc0mvKLcxDfMisrrapF2xQSuYtdB/BiJF2I+6g4aShZ4nEIdZDVOv9
         AEOu40Ig6J4qUuoWjplIOw0xmIzC3hnk52CbKLF4r68wQtGIMy3bTLPn07BP2iAa4H
         qcM8B9No0s0PwtXIE0covDT8tzVr5YIG8wF6xVwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/41] kbuild: Add resolve_btfids clean to root clean target
Date:   Fri,  9 Apr 2021 11:53:57 +0200
Message-Id: <20210409095305.936373764@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
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
index cb76f64abb6d..3a3937ab7ed0 100644
--- a/Makefile
+++ b/Makefile
@@ -1083,6 +1083,11 @@ ifdef CONFIG_STACK_VALIDATION
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
@@ -1500,7 +1505,7 @@ vmlinuxclean:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
 
-clean: archclean vmlinuxclean
+clean: archclean vmlinuxclean resolve_btfids_clean
 
 # mrproper - Delete all generated files, including .config
 #
-- 
2.30.2



