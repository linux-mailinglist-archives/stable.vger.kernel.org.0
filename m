Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC735944C1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344944AbiHOV5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350676AbiHOV4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:56:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A052261D5A;
        Mon, 15 Aug 2022 12:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DEA06111E;
        Mon, 15 Aug 2022 19:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31B5C433C1;
        Mon, 15 Aug 2022 19:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592055;
        bh=He9yFZ0PBN2pXNs4et5MYLrZXmt8FEEOC+rpwFysooI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8k33mugp3EaYHbv3uCDgq2FX9mwZ5nr3EHMqV6HP2GKK8NGR0ShGqiozBTApTy6F
         j0LgDi2cPAwQikCQjzkzgHKmYuHqQ4Cdg/oOF4R4sud0OME9VC5k3MFa2e9l44sQjH
         G74hRHNgTo8mntl67EOW+E9GGAug2E57rU4LL0gI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 5.19 0050/1157] LoongArch: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
Date:   Mon, 15 Aug 2022 19:50:06 +0200
Message-Id: <20220815180441.456232544@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 28e112afa44ad0814120d41c68fa72372a2cd2c2 upstream.

When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
cpu_max_bits_warn() generates a runtime warning similar as below while
we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
instead of NR_CPUS to iterate CPUs.

[    3.052463] ------------[ cut here ]------------
[    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
[    3.070072] Modules linked in: efivarfs autofs4
[    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
[    3.084034] Hardware name: Loongson Loongson-3A5000-7A1000-1w-V0.1-CRB/Loongson-LS3A5000-7A1000-1w-EVB-V1.21, BIOS Loongson-UDK2018-V2.0.04082-beta7 04/27
[    3.099465] Stack : 9000000100157b08 9000000000f18530 9000000000cf846c 9000000100154000
[    3.109127]         9000000100157a50 0000000000000000 9000000100157a58 9000000000ef7430
[    3.118774]         90000001001578e8 0000000000000040 0000000000000020 ffffffffffffffff
[    3.128412]         0000000000aaaaaa 1ab25f00eec96a37 900000010021de80 900000000101c890
[    3.138056]         0000000000000000 0000000000000000 0000000000000000 0000000000aaaaaa
[    3.147711]         ffff8000339dc220 0000000000000001 0000000006ab4000 0000000000000000
[    3.157364]         900000000101c998 0000000000000004 9000000000ef7430 0000000000000000
[    3.167012]         0000000000000009 000000000000006c 0000000000000000 0000000000000000
[    3.176641]         9000000000d3de08 9000000001639390 90000000002086d8 00007ffff0080286
[    3.186260]         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
[    3.195868]         ...
[    3.199917] Call Trace:
[    3.203941] [<90000000002086d8>] show_stack+0x38/0x14c
[    3.210666] [<9000000000cf846c>] dump_stack_lvl+0x60/0x88
[    3.217625] [<900000000023d268>] __warn+0xd0/0x100
[    3.223958] [<9000000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
[    3.231150] [<9000000000210220>] show_cpuinfo+0x5e8/0x5f0
[    3.238080] [<90000000004f578c>] seq_read_iter+0x354/0x4b4
[    3.245098] [<90000000004c2e90>] new_sync_read+0x17c/0x1c4
[    3.252114] [<90000000004c5174>] vfs_read+0x138/0x1d0
[    3.258694] [<90000000004c55f8>] ksys_read+0x70/0x100
[    3.265265] [<9000000000cfde9c>] do_syscall+0x7c/0x94
[    3.271820] [<9000000000202fe4>] handle_syscall+0xc4/0x160
[    3.281824] ---[ end trace 8b484262b4b8c24c ]---

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/proc.c
+++ b/arch/loongarch/kernel/proc.c
@@ -106,7 +106,7 @@ static void *c_start(struct seq_file *m,
 {
 	unsigned long i = *pos;
 
-	return i < NR_CPUS ? (void *)(i + 1) : NULL;
+	return i < nr_cpu_ids ? (void *)(i + 1) : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)


