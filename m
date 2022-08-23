Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99BF59DC10
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353393AbiHWKOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353696AbiHWKLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD168E5C;
        Tue, 23 Aug 2022 01:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF3361561;
        Tue, 23 Aug 2022 08:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1571FC433C1;
        Tue, 23 Aug 2022 08:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245096;
        bh=zZLL++bYvl0F92rMoTpAbVJJgVpyIgrqAToCvPmUEYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ugn5F5tglJQKSUPwXFIg/zWaZG+8j2aM6IMkXz8o850xcdOHms1Ig4vYjqKQwLMyG
         +YktQjAfVs/gecCFIVkuyqZ2elsRHTd1ee8lag7+hwe3z62MLxbagepBtQ66yB5zB2
         ncqjlVS6yo+xtb5JC+37t2+0BeBDDhhqR+wR4Cxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/244] modules: Ensure natural alignment for .altinstructions and __bug_table sections
Date:   Tue, 23 Aug 2022 10:26:11 +0200
Message-Id: <20220823080106.579362565@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 87c482bdfa79f378297d92af49cdf265be199df5 ]

In the kernel image vmlinux.lds.S linker scripts the .altinstructions
and __bug_table sections are 4- or 8-byte aligned because they hold 32-
and/or 64-bit values.

Most architectures use altinstructions and BUG() or WARN() in modules as
well, but in the module linker script (module.lds.S) those sections are
currently missing. As consequence the linker will store their content
byte-aligned by default, which then can lead to unnecessary unaligned
memory accesses by the CPU when those tables are processed at runtime.

Usually unaligned memory accesses are unnoticed, because either the
hardware (as on x86 CPUs) or in-kernel exception handlers (e.g. on
parisc or sparc) emulate and fix them up at runtime. Nevertheless, such
unaligned accesses introduce a performance penalty and can even crash
the kernel if there is a bug in the unalignment exception handlers
(which happened once to me on the parisc architecture and which is why I
noticed that issue at all).

This patch fixes a non-critical issue and might be backported at any time.
It's trivial and shouldn't introduce any regression because it simply
tells the linker to use a different (8-byte alignment) for those
sections by default.

Signed-off-by: Helge Deller <deller@gmx.de>
Link: https://lore.kernel.org/all/Yr8%2Fgr8e8I7tVX4d@p100/
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/module.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 1d0e1e4dc3d2..3a3aa2354ed8 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -27,6 +27,8 @@ SECTIONS {
 	.ctors			0 : ALIGN(8) { *(SORT(.ctors.*)) *(.ctors) }
 	.init_array		0 : ALIGN(8) { *(SORT(.init_array.*)) *(.init_array) }
 
+	.altinstructions	0 : ALIGN(8) { KEEP(*(.altinstructions)) }
+	__bug_table		0 : ALIGN(8) { KEEP(*(__bug_table)) }
 	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
 
 	__patchable_function_entries : { *(__patchable_function_entries) }
-- 
2.35.1



