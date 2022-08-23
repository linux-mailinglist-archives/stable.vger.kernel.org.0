Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCF659DB47
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354017AbiHWKYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355087AbiHWKWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:22:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040EF65575;
        Tue, 23 Aug 2022 02:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D7E6FCE1B5A;
        Tue, 23 Aug 2022 09:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D609EC433C1;
        Tue, 23 Aug 2022 09:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245428;
        bh=URJ8rVHxJKof51A0r40cqxZ3MM7znbwZb7Mc/fngO9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ano+yQh9IHGuZE5BvzpSZaNxIaF86c3H9X0tiWqXbmu7el2am711ZHv5qNFJzAypg
         CSMYOaFhPzr1px4BWxHR6G5fsMRUmhrbG0MIj2s6Vd0GnZPh9P+KDazGnQWwPDgaZs
         IkLGogTQsYctdtw6Sgbj4xwKTjVbP6wCrgZ7ZRJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.19 035/287] MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
Date:   Tue, 23 Aug 2022 10:23:24 +0200
Message-Id: <20220823080101.452207441@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

commit e1a534f5d074db45ae5cbac41d8912b98e96a006 upstream.

When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
cpu_max_bits_warn() generates a runtime warning similar as below while
we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
instead of NR_CPUS to iterate CPUs.

[    3.052463] ------------[ cut here ]------------
[    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
[    3.070072] Modules linked in: efivarfs autofs4
[    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
[    3.084034] Hardware name: Loongson Loongson-3A4000-7A1000-1w-V0.1-CRB/Loongson-LS3A4000-7A1000-1w-EVB-V1.21, BIOS Loongson-UDK2018-V2.0.04082-beta7 04/27
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
[    3.203941] [<98000000002086d8>] show_stack+0x38/0x14c
[    3.210666] [<9800000000cf846c>] dump_stack_lvl+0x60/0x88
[    3.217625] [<980000000023d268>] __warn+0xd0/0x100
[    3.223958] [<9800000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
[    3.231150] [<9800000000210220>] show_cpuinfo+0x5e8/0x5f0
[    3.238080] [<98000000004f578c>] seq_read_iter+0x354/0x4b4
[    3.245098] [<98000000004c2e90>] new_sync_read+0x17c/0x1c4
[    3.252114] [<98000000004c5174>] vfs_read+0x138/0x1d0
[    3.258694] [<98000000004c55f8>] ksys_read+0x70/0x100
[    3.265265] [<9800000000cfde9c>] do_syscall+0x7c/0x94
[    3.271820] [<9800000000202fe4>] handle_syscall+0xc4/0x160
[    3.281824] ---[ end trace 8b484262b4b8c24c ]---

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -168,7 +168,7 @@ static void *c_start(struct seq_file *m,
 {
 	unsigned long i = *pos;
 
-	return i < NR_CPUS ? (void *) (i + 1) : NULL;
+	return i < nr_cpu_ids ? (void *) (i + 1) : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)


