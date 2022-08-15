Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8881594084
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243515AbiHOVW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244967AbiHOVUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:20:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD6EE42E7;
        Mon, 15 Aug 2022 12:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 632CA60EF0;
        Mon, 15 Aug 2022 19:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E4CC433D6;
        Mon, 15 Aug 2022 19:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591330;
        bh=COkNRrEX6w4UbdnjU7Ri0CSOfhCU3mGHHhJ6+4yGcDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Il49eU3aS3PL4347rvBqoAxpWTpg5pBbupvVA+Jgw5eMBRktSiUkVVDnc6zl1eiDT
         hV530UGeH/bUHRuVa9oZwvLv93kP4kWa0cIlaPSMMRzcP3S+HDui0wm1oXUOUBGu7i
         tqg6MhjmI/e+au+yveuXs9Md2HG8ZaTTq7Qzs2CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>,
        Prakhar Srivastava <prsriva@linux.microsoft.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Rob Herring <robh@kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0546/1095] of: check previous kernels ima-kexec-buffer against memory bounds
Date:   Mon, 15 Aug 2022 19:59:05 +0200
Message-Id: <20220815180452.139243461@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit cbf9c4b9617b6767886a913705ca14b7600c77db ]

Presently ima_get_kexec_buffer() doesn't check if the previous kernel's
ima-kexec-buffer lies outside the addressable memory range. This can result
in a kernel panic if the new kernel is booted with 'mem=X' arg and the
ima-kexec-buffer was allocated beyond that range by the previous kernel.
The panic is usually of the form below:

$ sudo kexec --initrd initrd vmlinux --append='mem=16G'

<snip>
 BUG: Unable to handle kernel data access on read at 0xc000c01fff7f0000
 Faulting instruction address: 0xc000000000837974
 Oops: Kernel access of bad area, sig: 11 [#1]
<snip>
 NIP [c000000000837974] ima_restore_measurement_list+0x94/0x6c0
 LR [c00000000083b55c] ima_load_kexec_buffer+0xac/0x160
 Call Trace:
 [c00000000371fa80] [c00000000083b55c] ima_load_kexec_buffer+0xac/0x160
 [c00000000371fb00] [c0000000020512c4] ima_init+0x80/0x108
 [c00000000371fb70] [c0000000020514dc] init_ima+0x4c/0x120
 [c00000000371fbf0] [c000000000012240] do_one_initcall+0x60/0x2c0
 [c00000000371fcc0] [c000000002004ad0] kernel_init_freeable+0x344/0x3ec
 [c00000000371fda0] [c0000000000128a4] kernel_init+0x34/0x1b0
 [c00000000371fe10] [c00000000000ce64] ret_from_kernel_thread+0x5c/0x64
 Instruction dump:
 f92100b8 f92100c0 90e10090 910100a0 4182050c 282a0017 3bc00000 40810330
 7c0802a6 fb610198 7c9b2378 f80101d0 <a1240000> 2c090001 40820614 e9240010
 ---[ end trace 0000000000000000 ]---

Fix this issue by checking returned PFN range of previous kernel's
ima-kexec-buffer with page_is_ram() to ensure correct memory bounds.

Fixes: 467d27824920 ("powerpc: ima: get the kexec buffer passed by the previous kernel")
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Prakhar Srivastava <prsriva@linux.microsoft.com>
Cc: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220531041446.3334259-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/kexec.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 8d374cc552be..91b04b04eec4 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -126,6 +126,7 @@ int ima_get_kexec_buffer(void **addr, size_t *size)
 {
 	int ret, len;
 	unsigned long tmp_addr;
+	unsigned long start_pfn, end_pfn;
 	size_t tmp_size;
 	const void *prop;
 
@@ -140,6 +141,22 @@ int ima_get_kexec_buffer(void **addr, size_t *size)
 	if (ret)
 		return ret;
 
+	/* Do some sanity on the returned size for the ima-kexec buffer */
+	if (!tmp_size)
+		return -ENOENT;
+
+	/*
+	 * Calculate the PFNs for the buffer and ensure
+	 * they are with in addressable memory.
+	 */
+	start_pfn = PHYS_PFN(tmp_addr);
+	end_pfn = PHYS_PFN(tmp_addr + tmp_size - 1);
+	if (!page_is_ram(start_pfn) || !page_is_ram(end_pfn)) {
+		pr_warn("IMA buffer at 0x%lx, size = 0x%zx beyond memory\n",
+			tmp_addr, tmp_size);
+		return -EINVAL;
+	}
+
 	*addr = __va(tmp_addr);
 	*size = tmp_size;
 
-- 
2.35.1



