Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2596E6437
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjDRMrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbjDRMrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D18167DD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:47:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A80633AE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8012CC433EF;
        Tue, 18 Apr 2023 12:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822024;
        bh=WtEf6LYaQpPeKRMrRzAK6lALPyBTCdEakP/xZRQLaE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9PLUDGteEt7IxJ0z8VjM1fu1Fe6mfigS1ltRccBWti+VHbsiQBu5T/6DkE8AzJM9
         5nuVwlxZiSYQ23mPyDkhCuQlhPMLfunWyFOIBhl//IU1TNLJ/T2PNUoKMpfrH7Rylf
         EQpUrWS2Z1oG40UhzbjKcwYMJK0aQW9Iew4d/rXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/134] Documentation: riscv: Document the sv57 VM layout
Date:   Tue, 18 Apr 2023 14:23:04 +0200
Message-Id: <20230418120317.634963478@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit dd3553793a759e4f7f21c1aaffd5cb2de7a0068d ]

RISC-V has been supporting the "sv57" address translation mode for a
while, but is has not been added to the VM layout documentation. Let
us fix that.

Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20221118171556.1612190-1-bjorn@kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Stable-dep-of: ef69d2559fe9 ("riscv: Move early dtb mapping into the fixmap region")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/riscv/vm-layout.rst | 36 +++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/riscv/vm-layout.rst b/Documentation/riscv/vm-layout.rst
index 5b36e45fef60b..3be44e74ec5d6 100644
--- a/Documentation/riscv/vm-layout.rst
+++ b/Documentation/riscv/vm-layout.rst
@@ -97,3 +97,39 @@ RISC-V Linux Kernel SV48
    ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | modules, BPF
    ffffffff80000000 |   -2    GB | ffffffffffffffff |    2 GB | kernel
   __________________|____________|__________________|_________|____________________________________________________________
+
+
+RISC-V Linux Kernel SV57
+------------------------
+
+::
+
+ ========================================================================================================================
+      Start addr    |   Offset   |     End addr     |  Size   | VM area description
+ ========================================================================================================================
+                    |            |                  |         |
+   0000000000000000 |   0        | 00ffffffffffffff |   64 PB | user-space virtual memory, different per mm
+  __________________|____________|__________________|_________|___________________________________________________________
+                    |            |                  |         |
+   0100000000000000 | +64     PB | feffffffffffffff | ~16K PB | ... huge, almost 64 bits wide hole of non-canonical
+                    |            |                  |         | virtual memory addresses up to the -64 PB
+                    |            |                  |         | starting offset of kernel mappings.
+  __________________|____________|__________________|_________|___________________________________________________________
+                                                              |
+                                                              | Kernel-space virtual memory, shared between all processes:
+  ____________________________________________________________|___________________________________________________________
+                    |            |                  |         |
+   ff1bfffffee00000 | -57     PB | ff1bfffffeffffff |    2 MB | fixmap
+   ff1bffffff000000 | -57     PB | ff1bffffffffffff |   16 MB | PCI io
+   ff1c000000000000 | -57     PB | ff1fffffffffffff |    1 PB | vmemmap
+   ff20000000000000 | -56     PB | ff5fffffffffffff |   16 PB | vmalloc/ioremap space
+   ff60000000000000 | -40     PB | ffdeffffffffffff |   32 PB | direct mapping of all physical memory
+   ffdf000000000000 |  -8     PB | fffffffeffffffff |    8 PB | kasan
+  __________________|____________|__________________|_________|____________________________________________________________
+                                                              |
+                                                              | Identical layout to the 39-bit one from here on:
+  ____________________________________________________________|____________________________________________________________
+                    |            |                  |         |
+   ffffffff00000000 |  -4     GB | ffffffff7fffffff |    2 GB | modules, BPF
+   ffffffff80000000 |  -2     GB | ffffffffffffffff |    2 GB | kernel
+  __________________|____________|__________________|_________|____________________________________________________________
-- 
2.39.2



