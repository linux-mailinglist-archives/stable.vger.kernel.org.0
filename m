Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA59C4A438C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245576AbiAaLVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378381AbiAaLUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9B5F6114C;
        Mon, 31 Jan 2022 11:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7161BC340E8;
        Mon, 31 Jan 2022 11:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628005;
        bh=yo2HdgKuwvwA7p/MnrO/cT8+coYM6M44nJwMQhWhpX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPTEsvTl44KUnQsk+BA/dkU+RZtvVjJy1NgozRDYBMFlj7AlFLw5CzBzfvsT83XY0
         jIP3a5xHNdVxaZ+i9JdHQe8IjSXoSvk4gJ7Y7UZKCiT0uRjNfMttjVThGZ0l5YNF+d
         daaVkfwkzyLvITMgZlDi95v/x7EkxZymFz1szRCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.16 061/200] arm64: extable: fix load_unaligned_zeropad() reg indices
Date:   Mon, 31 Jan 2022 11:55:24 +0100
Message-Id: <20220131105235.627000123@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgenii Stepanov <eugenis@google.com>

commit 3758a6c74e08bdc15ccccd6872a6ad37d165239a upstream.

In ex_handler_load_unaligned_zeropad() we erroneously extract the data and
addr register indices from ex->type rather than ex->data. As ex->type will
contain EX_TYPE_LOAD_UNALIGNED_ZEROPAD (i.e. 4):
 * We'll always treat X0 as the address register, since EX_DATA_REG_ADDR is
   extracted from bits [9:5]. Thus, we may attempt to dereference an
   arbitrary address as X0 may hold an arbitrary value.
 * We'll always treat X4 as the data register, since EX_DATA_REG_DATA is
   extracted from bits [4:0]. Thus we will corrupt X4 and cause arbitrary
   behaviour within load_unaligned_zeropad() and its caller.

Fix this by extracting both values from ex->data as originally intended.

On an MTE-enabled QEMU image we are hitting the following crash:
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
 Call trace:
  fixup_exception+0xc4/0x108
  __do_kernel_fault+0x3c/0x268
  do_tag_check_fault+0x3c/0x104
  do_mem_abort+0x44/0xf4
  el1_abort+0x40/0x64
  el1h_64_sync_handler+0x60/0xa0
  el1h_64_sync+0x7c/0x80
  link_path_walk+0x150/0x344
  path_openat+0xa0/0x7dc
  do_filp_open+0xb8/0x168
  do_sys_openat2+0x88/0x17c
  __arm64_sys_openat+0x74/0xa0
  invoke_syscall+0x48/0x148
  el0_svc_common+0xb8/0xf8
  do_el0_svc+0x28/0x88
  el0_svc+0x24/0x84
  el0t_64_sync_handler+0x88/0xec
  el0t_64_sync+0x1b4/0x1b8
 Code: f8695a69 71007d1f 540000e0 927df12a (f940014a)

Fixes: 753b32368705 ("arm64: extable: add load_unaligned_zeropad() handler")
Cc: <stable@vger.kernel.org> # 5.16.x
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Evgenii Stepanov <eugenis@google.com>
Link: https://lore.kernel.org/r/20220125182217.2605202-1-eugenis@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/extable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -43,8 +43,8 @@ static bool
 ex_handler_load_unaligned_zeropad(const struct exception_table_entry *ex,
 				  struct pt_regs *regs)
 {
-	int reg_data = FIELD_GET(EX_DATA_REG_DATA, ex->type);
-	int reg_addr = FIELD_GET(EX_DATA_REG_ADDR, ex->type);
+	int reg_data = FIELD_GET(EX_DATA_REG_DATA, ex->data);
+	int reg_addr = FIELD_GET(EX_DATA_REG_ADDR, ex->data);
 	unsigned long data, addr, offset;
 
 	addr = pt_regs_read_reg(regs, reg_addr);


