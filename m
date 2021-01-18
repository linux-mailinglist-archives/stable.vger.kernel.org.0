Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9702FA8C5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407604AbhARS1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:27:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390744AbhARLlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D343322573;
        Mon, 18 Jan 2021 11:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970079;
        bh=thbQxZcpRcG6YQUeXHtrSfFQmzDOIk0PXEA3boSIkEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tobtOu8VcOYlFadKZhvXRA52FWAbaYr3ChXfw/HdWluMa9Sln2B/Kr9wZ4KrdqVqC
         mFTTawKQgd9g25/+lgCTdqzHSUG2KOv8v9dCrNgHUYCUujM36HSKMZgl8ssL4giKB2
         PKOlTy3+sQr+HTb1dX3ajOS/eHtXcediipZRG/s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Hu <nickhu@andestech.com>,
        Nylon Chen <nylon7@andestech.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 028/152] riscv: Fix KASAN memory mapping.
Date:   Mon, 18 Jan 2021 12:33:23 +0100
Message-Id: <20210118113354.130434971@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Hu <nickhu@andestech.com>

commit c25a053e15778f6b4d6553708673736e27a6c2cf upstream.

Use virtual address instead of physical address when translating
the address to shadow memory by kasan_mem_to_shadow().

Signed-off-by: Nick Hu <nickhu@andestech.com>
Signed-off-by: Nylon Chen <nylon7@andestech.com>
Fixes: b10d6bca8720 ("arch, drivers: replace for_each_membock() with for_each_mem_range()")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/mm/kasan_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -93,8 +93,8 @@ void __init kasan_init(void)
 								VMALLOC_END));
 
 	for_each_mem_range(i, &_start, &_end) {
-		void *start = (void *)_start;
-		void *end = (void *)_end;
+		void *start = (void *)__va(_start);
+		void *end = (void *)__va(_end);
 
 		if (start >= end)
 			break;


