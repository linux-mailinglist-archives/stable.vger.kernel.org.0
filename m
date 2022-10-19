Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E6C603F10
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiJSJ1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiJSJ02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086C1DEF39;
        Wed, 19 Oct 2022 02:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9B7561866;
        Wed, 19 Oct 2022 09:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB96CC433D6;
        Wed, 19 Oct 2022 09:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170561;
        bh=KJQPpJ32UIqN4u7A8mzjqm34rg4kJPRAbyTUOPAsbIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecTx8QnsGYvMZ06Z476vbfHu10D5Vg5TwyAj5YTXJwmakUuIX1eJnvMRREWr/PL1X
         SCp4zexjTngytuFJ1w/0lx214ggSG8BScasZuNkfx3oWB+54mCsM9DU8pLRAoHb4Th
         YlRfgBB1NhyzjSUn/ISoCghoMO9kZKC4f6OkT1/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 674/862] ARM: decompressor: Include .data.rel.ro.local
Date:   Wed, 19 Oct 2022 10:32:41 +0200
Message-Id: <20221019083319.746621086@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



