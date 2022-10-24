Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E063960BA35
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiJXU3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiJXU3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:29:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D0710F8AF;
        Mon, 24 Oct 2022 11:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A528CE16DE;
        Mon, 24 Oct 2022 12:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A430C433D6;
        Mon, 24 Oct 2022 12:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615856;
        bh=KJQPpJ32UIqN4u7A8mzjqm34rg4kJPRAbyTUOPAsbIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvUisClKraLRx0/yysAjMTJ52+ZjjdkS9QaL1/q7pZz0GSR/89LL28asOdgnsl6B3
         KMCepmu4dAQafTZbXqNPKjuy2TjQz0fPA33BR99l129+LOFt7vru0n/v2wN6TlTco8
         Mi5GPPIMBsCTht3xfqkpt+jo5SePQRloc4mOuYFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/530] ARM: decompressor: Include .data.rel.ro.local
Date:   Mon, 24 Oct 2022 13:32:34 +0200
Message-Id: <20221024113103.643088356@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



