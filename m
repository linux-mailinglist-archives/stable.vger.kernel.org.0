Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDD23D2A3D
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhGVQKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234552AbhGVQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 643D461D8D;
        Thu, 22 Jul 2021 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972535;
        bh=IfgRyMBp5WCC5nAcdE+UyzPSeIZNOJjPD5cYqMbaiPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zD6oywDdYVlAcmEDQWebtTrCTRKeWdlelZRk18tbUwlssYPv1mlUWpqpFFfYIsdgB
         f4+PjeqP98i0ILeh7RBi2loNSG2jSIRiq6mGWDlgpmK+wZm6y7AK2MHYvA8nTJh9v0
         CUU1ta/QKKlf0DR2p8BCFN9RqDZf8zxZuB048g18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.13 148/156] tools: bpf: Fix error in make -C tools/ bpf_install
Date:   Thu, 22 Jul 2021 18:32:03 +0200
Message-Id: <20210722155633.127016400@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

commit 1d719254c139fb62fb8056fb496b6fd007e71550 upstream.

make[2]: *** No rule to make target 'install'.  Stop.
make[1]: *** [Makefile:122: runqslower_install] Error 2
make: *** [Makefile:116: bpf_install] Error 2

There is no rule for target 'install' in tools/bpf/runqslower/Makefile,
and there is no need to install it, so just remove 'runqslower_install'.

Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210628030409.3459095-1-liwei391@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/Makefile |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -97,7 +97,7 @@ clean: bpftool_clean runqslower_clean re
 	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpf
 	$(Q)$(RM) -r -- $(OUTPUT)feature
 
-install: $(PROGS) bpftool_install runqslower_install
+install: $(PROGS) bpftool_install
 	$(call QUIET_INSTALL, bpf_jit_disasm)
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/bin
 	$(Q)$(INSTALL) $(OUTPUT)bpf_jit_disasm $(DESTDIR)$(prefix)/bin/bpf_jit_disasm
@@ -118,9 +118,6 @@ bpftool_clean:
 runqslower:
 	$(call descend,runqslower)
 
-runqslower_install:
-	$(call descend,runqslower,install)
-
 runqslower_clean:
 	$(call descend,runqslower,clean)
 
@@ -131,5 +128,5 @@ resolve_btfids_clean:
 	$(call descend,resolve_btfids,clean)
 
 .PHONY: all install clean bpftool bpftool_install bpftool_clean \
-	runqslower runqslower_install runqslower_clean \
+	runqslower runqslower_clean \
 	resolve_btfids resolve_btfids_clean


