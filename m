Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F9A4B4A7C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbiBNK1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348488AbiBNK1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:27:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EEB70305;
        Mon, 14 Feb 2022 01:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3710760909;
        Mon, 14 Feb 2022 09:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BBFC340E9;
        Mon, 14 Feb 2022 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832681;
        bh=Mx1SGZUBK1BtI9k1C8LaoJvamGvMNJDsqdlUYTo9V3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUKgJ755KdXqvatwPSPuq0nViyLgyOuaIWtdIeRzy2shh2M/+sipoUNDMS1H6DlNR
         Be3zfWwBVPr2zle79aZZ4is7atmrJvtzoXEEgC5QZ9qe9gZ4lsV35jGVsNXf0L7aRy
         IAfhDA7NssO5KJ4H22/gqgfwjydf/buSiGVPr9hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Myrtle Shah <gatecat@ds0.me>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 074/203] riscv: Fix XIP_FIXUP_FLASH_OFFSET
Date:   Mon, 14 Feb 2022 10:25:18 +0100
Message-Id: <20220214092512.792653468@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Myrtle Shah <gatecat@ds0.me>

commit 3c04d84508b54fcf524093b0d4a718680ed67f0f upstream.

There were several problems with the calculation. Not only was an 'and'
being computed into t1 but thrown away; but the 'and' itself would
cause problems if the granularity of the XIP physical address was less
than XIP_OFFSET - in my case I had the kernel image at 2MB in SPI flash.

Fixes: f9ace4ede49b ("riscv: remove .text section size limitation for XIP")
Cc: stable@vger.kernel.org
Signed-off-by: Myrtle Shah <gatecat@ds0.me>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/head.S |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -21,14 +21,13 @@
 	add \reg, \reg, t0
 .endm
 .macro XIP_FIXUP_FLASH_OFFSET reg
-	la t1, __data_loc
-	li t0, XIP_OFFSET_MASK
-	and t1, t1, t0
-	li t1, XIP_OFFSET
-	sub t0, t0, t1
-	sub \reg, \reg, t0
+	la t0, __data_loc
+	REG_L t1, _xip_phys_offset
+	sub \reg, \reg, t1
+	add \reg, \reg, t0
 .endm
 _xip_fixup: .dword CONFIG_PHYS_RAM_BASE - CONFIG_XIP_PHYS_ADDR - XIP_OFFSET
+_xip_phys_offset: .dword CONFIG_XIP_PHYS_ADDR + XIP_OFFSET
 #else
 .macro XIP_FIXUP_OFFSET reg
 .endm


