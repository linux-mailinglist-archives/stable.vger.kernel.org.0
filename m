Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4C55F8E13
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiJIUxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiJIUwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:52:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FE32FFF8;
        Sun,  9 Oct 2022 13:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E451B80DC2;
        Sun,  9 Oct 2022 20:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A25C433D6;
        Sun,  9 Oct 2022 20:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348733;
        bh=KJQPpJ32UIqN4u7A8mzjqm34rg4kJPRAbyTUOPAsbIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MK7AFfjLR3+lH5s3JsQGgAjI5GXkNs7DxsLi0dmQat9NRbgUoMm3X8d7txW5i2XR/
         7tyaTbip0nXDMIwM3fyC+94jSS6n7cyOFqh5ne05lKpmj+7pD/ulhQ1obR8svul8wY
         svR+Ex8zBqzMw3l4nNexvVL3GWXPCa9erdxk/wgWjp8Xkm+N92mniRBjBoCUqO1Co/
         x89p7LpTfDVYufY1E95D3tOD7u66H+CiQQP9N8ZHitzkx/QkM2wtjPyltQ+o14k+tP
         N4PxwGUTsTG1GTGzj9euf3wPpyn3j5TJRvqrjn2zS8gJeKULWMoFNW/2TMjOZHZ4sJ
         vAWY6uzvUQg7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.0 14/18] ARM: decompressor: Include .data.rel.ro.local
Date:   Sun,  9 Oct 2022 16:51:31 -0400
Message-Id: <20221009205136.1201774-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205136.1201774-1-sashal@kernel.org>
References: <20221009205136.1201774-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1b64daf413acd86c2c13f5443f6b4ef3690c8061 ]

The .data.rel.ro.local section has the same semantics as .data.rel.ro
here, so include it in the .rodata section of the decompressor.
Additionally since the .printk_index section isn't usable outside of
the core kernel, discard it in the decompressor. Avoids these warnings:

arm-linux-gnueabi-ld: warning: orphan section `.data.rel.ro.local' from `arch/arm/boot/compressed/fdt_rw.o' being placed in section `.data.rel.ro.local'
arm-linux-gnueabi-ld: warning: orphan section `.printk_index' from `arch/arm/boot/compressed/fdt_rw.o' being placed in section `.printk_index'

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-mm/202209080545.qMIVj7YM-lkp@intel.com
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index 1bcb68ac4b01..3fcb3e62dc56 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -23,6 +23,7 @@ SECTIONS
     *(.ARM.extab*)
     *(.note.*)
     *(.rel.*)
+    *(.printk_index)
     /*
      * Discard any r/w data - this produces a link error if we have any,
      * which is required for PIC decompression.  Local data generates
@@ -57,6 +58,7 @@ SECTIONS
     *(.rodata)
     *(.rodata.*)
     *(.data.rel.ro)
+    *(.data.rel.ro.*)
   }
   .piggydata : {
     *(.piggydata)
-- 
2.35.1

