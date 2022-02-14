Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A124C4B4B93
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbiBNKaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:30:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347423AbiBNK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:29:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909D570903;
        Mon, 14 Feb 2022 01:58:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02EC860909;
        Mon, 14 Feb 2022 09:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EA7C340EF;
        Mon, 14 Feb 2022 09:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832718;
        bh=KQ+9AInoANFoWzhgLj+DNeCDUD5Jcu/QtFa5pulHFos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXWyvypzeXpQzLG05XYxYqR8UmagGjHjd9eDOKNb6D/IDxCOA+8YtsWprl5MXkpmg
         jo66EjVnBi9aRdzmixtGh0DO2IaPWb5kFjmRiTmLcZGDpT+Mrd0+7VoRNQbCdwgarD
         H2HT8/7cdwCsoTb2eUsejhDvcWGoXozLeHYhQg3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pingfan Liu <kernelfans@gmail.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 075/203] riscv: cpu-hotplug: clear cpu from numa map when teardown
Date:   Mon, 14 Feb 2022 10:25:19 +0100
Message-Id: <20220214092512.830651630@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

commit f40fe31c01445f31253b15bef2412b33ae31093b upstream.

There is numa_add_cpu() when cpus online, accordingly, there should be
numa_remove_cpu() when cpus offline.

Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Fixes: 4f0e8eef772e ("riscv: Add numa support for riscv64 platform")
Cc: stable@vger.kernel.org
[Palmer: Add missing NUMA include]
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cpu-hotplug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -12,6 +12,7 @@
 #include <linux/sched/hotplug.h>
 #include <asm/irq.h>
 #include <asm/cpu_ops.h>
+#include <asm/numa.h>
 #include <asm/sbi.h>
 
 void cpu_stop(void);
@@ -46,6 +47,7 @@ int __cpu_disable(void)
 		return ret;
 
 	remove_cpu_topology(cpu);
+	numa_remove_cpu(cpu);
 	set_cpu_online(cpu, false);
 	irq_migrate_all_off_this_cpu();
 


