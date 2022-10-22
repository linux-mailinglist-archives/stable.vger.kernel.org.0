Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AEC6089EF
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiJVIpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiJVIn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:43:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F772EA957;
        Sat, 22 Oct 2022 01:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 708A260B83;
        Sat, 22 Oct 2022 07:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16257C433C1;
        Sat, 22 Oct 2022 07:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425595;
        bh=KJQPpJ32UIqN4u7A8mzjqm34rg4kJPRAbyTUOPAsbIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyYMYy0XiVg2wqEGk118QpqI4Jwj7lUfHboCqgbkndWVHHMad91hfK1qhx/8C803T
         J38Azsq5Qyb2u3SU3UXJ9TbOs/x46YZxwOHVqoo2OBL1RezjN1hIkQQzpR+alHpdGR
         44I2RBx6I1Pur7OL+hdLlIiEUIXj8KpbtOudLbHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 551/717] ARM: decompressor: Include .data.rel.ro.local
Date:   Sat, 22 Oct 2022 09:27:10 +0200
Message-Id: <20221022072522.740344747@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



