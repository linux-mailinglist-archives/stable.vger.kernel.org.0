Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D011A1333B6
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAGVDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbgAGVDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD95214D8;
        Tue,  7 Jan 2020 21:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431003;
        bh=qw+nnA4BJ0MRDlYO03FDH+s5K6CRzbmFiiJjv7eTQwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gN6lRcRhc7hk0P7foHNLpMIBzDPGlA/wqP632BBYXTHRPnpaz975/Hfy6ovtnqxA0
         QNeHIYJvpqfAVh4lhXEp9YZ8ZxApMQVp79eSe8hn7/9hpxrJ2O+CuZZxsqEJ3x5bsn
         /7wvx3DeE4W2lWh+Ppm6W2GG1p+23TSEWoaCI0Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Narron <comet.berkeley@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/191] efi: Dont attempt to map RCI2 config table if it doesnt exist
Date:   Tue,  7 Jan 2020 21:55:05 +0100
Message-Id: <20200107205342.891416884@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit a470552ee8965da0fe6fd4df0aa39c4cda652c7c ]

Commit:

  1c5fecb61255aa12 ("efi: Export Runtime Configuration Interface table to sysfs")

... added support for a Dell specific UEFI configuration table, but
failed to take into account that mapping the table should not be
attempted unless the table actually exists. If it doesn't exist,
the code usually fails silently unless pr_debug() prints are
enabled. However, on 32-bit PAE x86, the splat below is produced due
to the attempt to map the placeholder value EFI_INVALID_TABLE_ADDR
which we use for non-existing UEFI configuration tables, and which
equals ULONG_MAX.

   memremap attempted on mixed range 0x00000000ffffffff size: 0x1e
   WARNING: CPU: 1 PID: 1 at kernel/iomem.c:81 memremap+0x1a3/0x1c0
   Modules linked in:
   CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.4.2-smp-mine #1
   Hardware name: Hewlett-Packard HP Z400 Workstation/0B4Ch, BIOS 786G3 v03.61 03/05/2018
   EIP: memremap+0x1a3/0x1c0
  ...
   Call Trace:
    ? map_properties+0x473/0x473
    ? efi_rci2_sysfs_init+0x2c/0x154
    ? map_properties+0x473/0x473
    ? do_one_initcall+0x49/0x1d4
    ? parse_args+0x1e8/0x2a0
    ? do_early_param+0x7a/0x7a
    ? kernel_init_freeable+0x139/0x1c2
    ? rest_init+0x8e/0x8e
    ? kernel_init+0xd/0xf2
    ? ret_from_fork+0x2e/0x38

Fix this by checking whether the table exists before attempting to map it.

Reported-by: Richard Narron <comet.berkeley@gmail.com>
Tested-by: Richard Narron <comet.berkeley@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Fixes: 1c5fecb61255aa12 ("efi: Export Runtime Configuration Interface table to sysfs")
Link: https://lkml.kernel.org/r/20191210090945.11501-2-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/rci2-table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/rci2-table.c b/drivers/firmware/efi/rci2-table.c
index 76b0c354a027..de1a9a1f9f14 100644
--- a/drivers/firmware/efi/rci2-table.c
+++ b/drivers/firmware/efi/rci2-table.c
@@ -81,6 +81,9 @@ static int __init efi_rci2_sysfs_init(void)
 	struct kobject *tables_kobj;
 	int ret = -ENOMEM;
 
+	if (rci2_table_phys == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
 	rci2_base = memremap(rci2_table_phys,
 			     sizeof(struct rci2_table_global_hdr),
 			     MEMREMAP_WB);
-- 
2.20.1



