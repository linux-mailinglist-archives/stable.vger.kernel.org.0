Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52CC3786E8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhEJLMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235602AbhEJLFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D444A6146E;
        Mon, 10 May 2021 10:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644134;
        bh=ixXvKLSy18G5CyVdi8WHqjtr8ZHOC6O9tOQOd402WhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkLTgFs6B7hblm7kQNlHJSQw5Vmz91XEdk582d1BNyLyJ30mzK2bzAC4p28t8UgSh
         bjZ6fUigi3jLC8XXuYCibRz2pVP9cSbqOQcIX32EghVMKFvX820pgfUNEUXWb6Whli
         kj8OQEl3VZn2Fq4rqtQgX4L8gWFTqxrMJFZD374o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elliot Berman <eberman@codeaurora.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.11 302/342] kbuild: update config_data.gz only when the content of .config is changed
Date:   Mon, 10 May 2021 12:21:32 +0200
Message-Id: <20210510102020.084385526@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 46b41d5dd8019b264717978c39c43313a524d033 upstream.

If the timestamp of the .config file is updated, config_data.gz is
regenerated, then vmlinux is re-linked. This occurs even if the content
of the .config has not changed at all.

This issue was mitigated by commit 67424f61f813 ("kconfig: do not write
.config if the content is the same"); Kconfig does not update the
.config when it ends up with the identical configuration.

The issue is remaining when the .config is created by *_defconfig with
some config fragment(s) applied on top.

This is typical for powerpc and mips, where several *_defconfig targets
are constructed by using merge_config.sh.

One workaround is to have the copy of the .config. The filechk rule
updates the copy, kernel/config_data, by checking the content instead
of the timestamp.

With this commit, the second run with the same configuration avoids
the needless rebuilds.

  $ make ARCH=mips defconfig all
   [ snip ]
  $ make ARCH=mips defconfig all
  *** Default configuration is based on target '32r2el_defconfig'
  Using ./arch/mips/configs/generic_defconfig as base
  Merging arch/mips/configs/generic/32r2.config
  Merging arch/mips/configs/generic/el.config
  Merging ./arch/mips/configs/generic/board-boston.config
  Merging ./arch/mips/configs/generic/board-ni169445.config
  Merging ./arch/mips/configs/generic/board-ocelot.config
  Merging ./arch/mips/configs/generic/board-ranchu.config
  Merging ./arch/mips/configs/generic/board-sead-3.config
  Merging ./arch/mips/configs/generic/board-xilfpga.config
  #
  # configuration written to .config
  #
    SYNC    include/config/auto.conf
    CALL    scripts/checksyscalls.sh
    CALL    scripts/atomic/check-atomics.sh
    CHK     include/generated/compile.h
    CHK     include/generated/autoksyms.h

Reported-by: Elliot Berman <eberman@codeaurora.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/.gitignore |    1 +
 kernel/Makefile   |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+/config_data
 kheaders.md5
 timeconst.h
 hz.bc
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -138,10 +138,15 @@ obj-$(CONFIG_SCF_TORTURE_TEST) += scftor
 
 $(obj)/configs.o: $(obj)/config_data.gz
 
-targets += config_data.gz
-$(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
+targets += config_data config_data.gz
+$(obj)/config_data.gz: $(obj)/config_data FORCE
 	$(call if_changed,gzip)
 
+filechk_cat = cat $<
+
+$(obj)/config_data: $(KCONFIG_CONFIG) FORCE
+	$(call filechk,cat)
+
 $(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
 
 quiet_cmd_genikh = CHK     $(obj)/kheaders_data.tar.xz


