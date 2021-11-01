Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD234418C4
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhKAJvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234785AbhKAJtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:49:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD4816124C;
        Mon,  1 Nov 2021 09:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759106;
        bh=4G1HQ7CISmEFbhY21iAW5sYWyDXpwVsEWm36BmAQGys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi40W8Zu+SNfGg1DRHSrgQefZXBQ4FrrCsECHqfaW1F0AOEq/Bp0GL+knvlU4zYf7
         C7yvDHxgiatmm07q9n2zzuDAOXKBunDjnW+M6v8ZaDl56r2BVljw11F8vLPGjzjXVk
         lGXNAQ3yULho1TN7eXPlMZCEoODjKXmcuBauAd1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Lu <181250012@smail.nju.edu.cn>,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.14 118/125] riscv: fix misalgned trap vector base address
Date:   Mon,  1 Nov 2021 10:18:11 +0100
Message-Id: <20211101082555.387655790@linuxfoundation.org>
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

From: Chen Lu <181250012@smail.nju.edu.cn>

commit 64a19591a2938b170aa736443d5d3bf4c51e1388 upstream.

The trap vector marked by label .Lsecondary_park must align on a
4-byte boundary, as the {m,s}tvec is defined to require 4-byte
alignment.

Signed-off-by: Chen Lu <181250012@smail.nju.edu.cn>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
Fixes: e011995e826f ("RISC-V: Move relocate and few other functions out of __init")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/head.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -193,6 +193,7 @@ setup_trap_vector:
 	csrw CSR_SCRATCH, zero
 	ret
 
+.align 2
 .Lsecondary_park:
 	/* We lack SMP support or have too many harts, so park this hart */
 	wfi


