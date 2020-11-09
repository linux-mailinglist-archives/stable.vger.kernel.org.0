Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5505D2AB9F6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733140AbgKINO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733129AbgKINOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92783208FE;
        Mon,  9 Nov 2020 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927665;
        bh=B/iMVp32s8YTZGPyk6xONGm3ZofyojNioae1DddPIXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWw1qNftbge0ZkgkNAlvhJ9V7+LWgyAIZBfR5XivOMoMy/ahSH0FY4718Rw+yjpYl
         QT6rfll3/2i1h89cHVI7cAgOdVbavuM6BDXeIzUnoOe8Z59r5J0RVSGRLucFs2yJmv
         op4R1uomfOdLXFpK9b173c/H0ri1cQlPT3E7fJME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Baurzhan Ismagulov <ibr@radix50.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.4 35/85] mtd: spi-nor: Dont copy self-pointing struct around
Date:   Mon,  9 Nov 2020 13:55:32 +0100
Message-Id: <20201109125024.281306237@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 69a8eed58cc09aea3b01a64997031dd5d3c02c07 upstream.

spi_nor_parse_sfdp() modifies the passed structure so that it points to
itself (params.erase_map.regions to params.erase_map.uniform_region). This
makes it impossible to copy the local struct anywhere else.

Therefore only use memcpy() in backup-restore scenario. The bug may show up
like below:

BUG: unable to handle page fault for address: ffffc90000b377f8
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 4 PID: 3500 Comm: flashcp Tainted: G           O      5.4.53-... #1
...
RIP: 0010:spi_nor_erase+0x8e/0x5c0
Code: 64 24 18 89 db 4d 8b b5 d0 04 00 00 4c 89 64 24 18 4c 89 64 24 20 eb 12 a8 10 0f 85 59 02 00 00 49 83 c6 10 0f 84 4f 02 00 00 <49> 8b 06 48 89 c2 48 83 e2 c0 48 89 d1 49 03 4e 08 48 39 cb 73 d8
RSP: 0018:ffffc9000217fc48 EFLAGS: 00010206
RAX: 0000000000740000 RBX: 0000000000000000 RCX: 0000000000740000
RDX: ffff8884550c9980 RSI: ffff88844f9c0bc0 RDI: ffff88844ede7bb8
RBP: 0000000000740000 R08: ffffffff815bfbe0 R09: ffff88844f9c0bc0
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc9000217fc60
R13: ffff88844ede7818 R14: ffffc90000b377f8 R15: 0000000000000000
FS:  00007f4699780500(0000) GS:ffff88846ff00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000b377f8 CR3: 00000004538ee000 CR4: 0000000000340fe0
Call Trace:
 part_erase+0x27/0x50
 mtdchar_ioctl+0x831/0xba0
 ? filemap_map_pages+0x186/0x3d0
 ? do_filp_open+0xad/0x110
 ? _copy_to_user+0x22/0x30
 ? cp_new_stat+0x150/0x180
 mtdchar_unlocked_ioctl+0x2a/0x40
 do_vfs_ioctl+0xa0/0x630
 ? __do_sys_newfstat+0x3c/0x60
 ksys_ioctl+0x70/0x80
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x6a/0x200
 ? prepare_exit_to_usermode+0x50/0xd0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f46996b6817

Cc: stable@vger.kernel.org
Fixes: c46872170a54 ("mtd: spi-nor: Move erase_map to 'struct spi_nor_flash_parameter'")
Co-developed-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Tested-by: Baurzhan Ismagulov <ibr@radix50.net>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201005084803.23460-1-alexander.sverdlin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/spi-nor.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -4444,11 +4444,10 @@ static void spi_nor_sfdp_init_params(str
 
 	memcpy(&sfdp_params, &nor->params, sizeof(sfdp_params));
 
-	if (spi_nor_parse_sfdp(nor, &sfdp_params)) {
+	if (spi_nor_parse_sfdp(nor, &nor->params)) {
+		memcpy(&nor->params, &sfdp_params, sizeof(nor->params));
 		nor->addr_width = 0;
 		nor->flags &= ~SNOR_F_4B_OPCODES;
-	} else {
-		memcpy(&nor->params, &sfdp_params, sizeof(nor->params));
 	}
 }
 


