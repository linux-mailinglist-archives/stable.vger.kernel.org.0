Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D1F59D5CD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbiHWJF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242352AbiHWJEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:04:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D959D83F2E;
        Tue, 23 Aug 2022 01:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24FAD61360;
        Tue, 23 Aug 2022 08:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA51C433C1;
        Tue, 23 Aug 2022 08:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243288;
        bh=8Jm9YYqLw/pElrVNBlgxZpV/Wi6IBZMDszQgvh2y7wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLY15dk6CmQSeOdKgvaQDLe2D296n7xHFbuvrXWz+zV7J/pOpy8Gf+cugtvPhDaul
         4NFH/DeN7Iiwzt7t2ozzpX1dAAIlHv/an6qdC/DK/jjyHfIcZpmxVhGQ3HZZrg3V/A
         BUzOeSNGhpno9b9ohMzZmR9S50r6QgqaTaOBSzEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        matoro <matoro_mailinglist_kernel@matoro.tk>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.19 228/365] modpost: fix module versioning when a symbol lacks valid CRC
Date:   Tue, 23 Aug 2022 10:02:09 +0200
Message-Id: <20220823080127.738695343@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 5b8a9a8fd1f0c3d55d407cf759d54ca68798d9ad upstream.

Since commit 7b4537199a4a ("kbuild: link symbol CRCs at final link,
removing CONFIG_MODULE_REL_CRCS"), module versioning is broken on
some architectures. Loading a module fails with "disagrees about
version of symbol module_layout".

On such architectures (e.g. ARCH=sparc build with sparc64_defconfig),
modpost shows a warning, like follows:

  WARNING: modpost: EXPORT symbol "_mcount" [vmlinux] version generation failed, symbol will not be versioned.
  Is "_mcount" prototyped in <asm/asm-prototypes.h>?

Previously, it was a harmless warning (CRC check was just skipped),
but now wrong CRCs are used for comparison because invalid CRCs are
just skipped.

  $ sparc64-linux-gnu-nm -n vmlinux
    [snip]
  0000000000c2cea0 r __ksymtab__kstrtol
  0000000000c2ceb8 r __ksymtab__kstrtoul
  0000000000c2ced0 r __ksymtab__local_bh_enable
  0000000000c2cee8 r __ksymtab__mcount
  0000000000c2cf00 r __ksymtab__printk
  0000000000c2cf18 r __ksymtab__raw_read_lock
  0000000000c2cf30 r __ksymtab__raw_read_lock_bh
    [snip]
  0000000000c53b34 D __crc__kstrtol
  0000000000c53b38 D __crc__kstrtoul
  0000000000c53b3c D __crc__local_bh_enable
  0000000000c53b40 D __crc__printk
  0000000000c53b44 D __crc__raw_read_lock
  0000000000c53b48 D __crc__raw_read_lock_bh

Please notice __crc__mcount is missing here.

When the module subsystem looks up a CRC that comes after, it results
in reading out a wrong address. For example, when __crc__printk is
needed, the module subsystem reads 0xc53b44 instead of 0xc53b40.

All CRC entries must be output for correct index accessing. Invalid
CRCs will be unused, but are needed to keep the one-to-one mapping
between __ksymtab_* and __crc_*.

The best is to fix all modpost warnings, but several warnings are still
remaining on less popular architectures.

Fixes: 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2203,13 +2203,11 @@ static void add_exported_symbols(struct
 	/* record CRCs for exported symbols */
 	buf_printf(buf, "\n");
 	list_for_each_entry(sym, &mod->exported_symbols, list) {
-		if (!sym->crc_valid) {
+		if (!sym->crc_valid)
 			warn("EXPORT symbol \"%s\" [%s%s] version generation failed, symbol will not be versioned.\n"
 			     "Is \"%s\" prototyped in <asm/asm-prototypes.h>?\n",
 			     sym->name, mod->name, mod->is_vmlinux ? "" : ".ko",
 			     sym->name);
-			continue;
-		}
 
 		buf_printf(buf, "SYMBOL_CRC(%s, 0x%08x, \"%s\");\n",
 			   sym->name, sym->crc, sym->is_gpl_only ? "_gpl" : "");


