Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF3744183D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhKAJpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233379AbhKAJmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD63961361;
        Mon,  1 Nov 2021 09:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758917;
        bh=DCP6dO+58ZLS2XiGY6MPSnAB4C/Yl4c0mS908OznUvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHSzjYTrCBI8r+NYRFqlzEbcBXlJJeVe1RoO5B61so0nZoMehWg+VDwBBQaRYUs6l
         v0qkRS1LnuFbyjAtchYUhV3S9/LxE5kScaruK7Kw9qSXz5QTpf67Y08I7Bu9w24rpS
         YUMTIxWTrIA4CCxSdrbrCye80bGnzpGx3QhCKjso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.14 007/125] ARM: 9148/1: handle CONFIG_CPU_ENDIAN_BE32 in arch/arm/kernel/head.S
Date:   Mon,  1 Nov 2021 10:16:20 +0100
Message-Id: <20211101082534.840569858@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: LABBE Corentin <clabbe.montjoie@gmail.com>

commit 00568b8a6364e15009b345b462e927e0b9fc2bb9 upstream.

My intel-ixp42x-welltech-epbx100 no longer boot since 4.14.
This is due to commit 463dbba4d189 ("ARM: 9104/2: Fix Keystone 2 kernel
mapping regression")
which forgot to handle CONFIG_CPU_ENDIAN_BE32 as possible BE config.

Suggested-by: Krzysztof Hałasa <khalasa@piap.pl>
Fixes: 463dbba4d189 ("ARM: 9104/2: Fix Keystone 2 kernel mapping regression")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/head.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -253,7 +253,7 @@ __create_page_tables:
 	add	r0, r4, #KERNEL_OFFSET >> (SECTION_SHIFT - PMD_ORDER)
 	ldr	r6, =(_end - 1)
 	adr_l	r5, kernel_sec_start		@ _pa(kernel_sec_start)
-#ifdef CONFIG_CPU_ENDIAN_BE8
+#if defined CONFIG_CPU_ENDIAN_BE8 || defined CONFIG_CPU_ENDIAN_BE32
 	str	r8, [r5, #4]			@ Save physical start of kernel (BE)
 #else
 	str	r8, [r5]			@ Save physical start of kernel (LE)
@@ -266,7 +266,7 @@ __create_page_tables:
 	bls	1b
 	eor	r3, r3, r7			@ Remove the MMU flags
 	adr_l	r5, kernel_sec_end		@ _pa(kernel_sec_end)
-#ifdef CONFIG_CPU_ENDIAN_BE8
+#if defined CONFIG_CPU_ENDIAN_BE8 || defined CONFIG_CPU_ENDIAN_BE32
 	str	r3, [r5, #4]			@ Save physical end of kernel (BE)
 #else
 	str	r3, [r5]			@ Save physical end of kernel (LE)


