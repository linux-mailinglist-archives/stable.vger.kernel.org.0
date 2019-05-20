Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFB0235EE
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388394AbfETMli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390277AbfETMbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:31:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 290EA21721;
        Mon, 20 May 2019 12:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355471;
        bh=rzy736CsgS0Y3zt/uwrEMZnuY8Zf2XnsR1lqWDYGqlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/VW0c5dvt9RSuvvaOe8dCOGZCcuVsH40e4vz8FqzIjWYH6+UJinioVT4VhkVfZ0r
         yVqXd4BD6sbH98sq3WNvmxG08iIXM5NdzA2IyKG9im92py1Q8sE5+kUZOikshMMxGC
         hKSVmfEDoOdcvYdYKU594Ze/TW6BmXW9lq9q8fas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>
Subject: [PATCH 5.0 101/123] tty: Dont force RISCV SBI console as preferred console
Date:   Mon, 20 May 2019 14:14:41 +0200
Message-Id: <20190520115251.749150249@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <Anup.Patel@wdc.com>

commit f91253a3d005796404ae0e578b3394459b5f9b71 upstream.

The Linux kernel will auto-disables all boot consoles whenever it
gets a preferred real console.

Currently on RISC-V systems, if we have a real console which is not
RISCV SBI console then boot consoles (such as earlycon=sbi) are not
auto-disabled when a real console (ttyS0 or ttySIF0) is available.
This results in duplicate prints at boot-time after kernel starts
using real console (i.e. ttyS0 or ttySIF0) if "earlycon=" kernel
parameter was passed by bootloader.

The reason for above issue is that RISCV SBI console always adds
itself as preferred console which is causing other real consoles
to be not used as preferred console.

Ideally "console=" kernel parameter passed by bootloaders should
be the one selecting a preferred real console.

This patch fixes above issue by not forcing RISCV SBI console as
preferred console.

Fixes: afa6b1ccfad5 ("tty: New RISC-V SBI console driver")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/hvc/hvc_riscv_sbi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/hvc/hvc_riscv_sbi.c
+++ b/drivers/tty/hvc/hvc_riscv_sbi.c
@@ -53,7 +53,6 @@ device_initcall(hvc_sbi_init);
 static int __init hvc_sbi_console_init(void)
 {
 	hvc_instantiate(0, 0, &hvc_sbi_ops);
-	add_preferred_console("hvc", 0, NULL);
 
 	return 0;
 }


