Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFED4B494F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347713AbiBNKbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347476AbiBNKaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681669969B;
        Mon, 14 Feb 2022 01:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5C10B80E02;
        Mon, 14 Feb 2022 09:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A60DC340E9;
        Mon, 14 Feb 2022 09:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832734;
        bh=PAJM3UNn5kgTW1Q50Bd3CjH0r2slOOk1wceAUWcc4+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAG5aNmB7Cy4shBmWvcwarKIqspJyeLMuXsf0Wh1UOQmvvFtsU3yPyK9lPDQwpPp4
         uEiDkAuIKEOZ+N1Zn1cUL3Kvog8SZOIISN5+mBQMEj/8kT+pkBEY+fDcMxIMqS4N/A
         fXGwFIu65Gdq4/XfM1JaZ42qMdR9VQJgTIQXfS+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Myrtle Shah <gatecat@ds0.me>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 076/203] riscv/mm: Add XIP_FIXUP for phys_ram_base
Date:   Mon, 14 Feb 2022 10:25:20 +0100
Message-Id: <20220214092512.862740072@linuxfoundation.org>
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

From: Palmer Dabbelt <palmer@rivosinc.com>

commit 4b1c70aa8ed8249608bb991380cb8ff423edf49e upstream.

This manifests as a crash early in boot on VexRiscv.

Signed-off-by: Myrtle Shah <gatecat@ds0.me>
[Palmer: split commit]
Fixes: 6d7f91d914bc ("riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical address conversion")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -41,6 +41,7 @@ phys_addr_t phys_ram_base __ro_after_ini
 EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_XIP_KERNEL
+#define phys_ram_base  (*(phys_addr_t *)XIP_FIXUP(&phys_ram_base))
 extern char _xiprom[], _exiprom[], __data_loc;
 #endif
 


