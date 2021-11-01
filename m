Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005EC4417EE
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhKAJlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhKAJjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 514A46112F;
        Mon,  1 Nov 2021 09:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758844;
        bh=xOmdrLMaR4ceIG50D7SxFSFU3GepjWv0UEegBLGgeQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7JSgKKq+5dsSeg+rkxnUiIGJEeb7nzkKC/Jiup2PzP9FG00SdvpjvFuxtUfLQmIE
         3v1MWt2YD7b503ythfSrYjGpx8yuLfmD2bKa2qPFHY11luCIc79EsBclHw6qrmTRXi
         K/U5wwXUmIx3REW1I8HxAQqh3YNvVFTtXtuzZlPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Lu <181250012@smail.nju.edu.cn>,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 75/77] riscv: fix misalgned trap vector base address
Date:   Mon,  1 Nov 2021 10:18:03 +0100
Message-Id: <20211101082527.164506260@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -175,6 +175,7 @@ setup_trap_vector:
 	csrw CSR_SCRATCH, zero
 	ret
 
+.align 2
 .Lsecondary_park:
 	/* We lack SMP support or have too many harts, so park this hart */
 	wfi


