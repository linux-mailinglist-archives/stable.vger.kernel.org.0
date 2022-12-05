Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACBB6432D1
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbiLETaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbiLET3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:29:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2817D2A729
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C4416131A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F30DC433C1;
        Mon,  5 Dec 2022 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268366;
        bh=ZPEcwlxSAlSYFdvr8SPLDAbU7FTX6XWVrnAybQy8PwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxqa1T5TnVIlAdWQjrJ5h1752yP7R1Pb60ADakibwPvoM1nnEqYoMxfEUO17JkTBW
         ko9QUVF5RvXrHrpnEXJFtbQmZkVkGoH1PjoEtFIZlsAirc4Q37Clzhx660nwkg+Mns
         yLLR4+F0woB485sg5OeVU8xONPRQ6YEBbcofWrxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 076/124] riscv: mm: Proper page permissions after initmem free
Date:   Mon,  5 Dec 2022 20:09:42 +0100
Message-Id: <20221205190810.579214841@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

commit 6fdd5d2f8c2f54b7fad4ff4df2a19542aeaf6102 upstream.

64-bit RISC-V kernels have the kernel image mapped separately to alias
the linear map. The linear map and the kernel image map are documented
as "direct mapping" and "kernel" respectively in [1].

At image load time, the linear map corresponding to the kernel image
is set to PAGE_READ permission, and the kernel image map is set to
PAGE_READ|PAGE_EXEC.

When the initmem is freed, the pages in the linear map should be
restored to PAGE_READ|PAGE_WRITE, whereas the corresponding pages in
the kernel image map should be restored to PAGE_READ, by removing the
PAGE_EXEC permission.

This is not the case. For 64-bit kernels, only the linear map is
restored to its proper page permissions at initmem free, and not the
kernel image map.

In practise this results in that the kernel can potentially jump to
dead __init code, and start executing invalid instructions, without
getting an exception.

Restore the freed initmem properly, by setting both the kernel image
map to the correct permissions.

[1] Documentation/riscv/vm-layout.rst

Fixes: e5c35fa04019 ("riscv: Map the kernel with correct permissions the first time")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
Tested-by: Alexandre Ghiti <alex@ghiti.fr>
Link: https://lore.kernel.org/r/20221115090641.258476-1-bjorn@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -322,10 +322,11 @@ subsys_initcall(topology_init);
 
 void free_initmem(void)
 {
-	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
-		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end),
-				  IS_ENABLED(CONFIG_64BIT) ?
-					set_memory_rw : set_memory_rw_nx);
+	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)) {
+		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end), set_memory_rw_nx);
+		if (IS_ENABLED(CONFIG_64BIT))
+			set_kernel_memory(__init_begin, __init_end, set_memory_nx);
+	}
 
 	free_initmem_default(POISON_FREE_INITMEM);
 }


