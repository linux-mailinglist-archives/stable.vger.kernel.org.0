Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC5966CC71
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbjAPR0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbjAPRZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:25:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1BD2799B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9ED261083
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2B0C433EF;
        Mon, 16 Jan 2023 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888575;
        bh=JQR16PqV81griDuD5kmiuabc3aoYxVr7yHbYMNbH/nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbRecTKAo3MT8031pFe59ZQk1fzQwHcSQRfBlDkiQ18LjcSsOt4XIFkoF8bo4Yl3I
         cQd3kTAsoZOrLfyeQE4800m9yqhX9LxNrjVzTbU1Tdk+YPmId3A1JB+Xb++g9Eah5j
         7rYbr8nYdeuIhA0XL1jsxG9e/w69tRem6+Oi+NS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 058/338] x86/xen: Fix memory leak in xen_init_lock_cpu()
Date:   Mon, 16 Jan 2023 16:48:51 +0100
Message-Id: <20230116154823.338223608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit ca84ce153d887b1dc8b118029976cc9faf2a9b40 ]

In xen_init_lock_cpu(), the @name has allocated new string by kasprintf(),
if bind_ipi_to_irqhandler() fails, it should be freed, otherwise may lead
to a memory leak issue, fix it.

Fixes: 2d9e1e2f58b5 ("xen: implement Xen-specific spinlocks")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221123155858.11382-3-xiujianfeng@huawei.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/spinlock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index e22ee2439615..957ef40b8772 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -81,6 +81,7 @@ void xen_init_lock_cpu(int cpu)
 	     cpu, per_cpu(lock_kicker_irq, cpu));
 
 	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
+	per_cpu(irq_name, cpu) = name;
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
 				     dummy_handler,
@@ -91,7 +92,6 @@ void xen_init_lock_cpu(int cpu)
 	if (irq >= 0) {
 		disable_irq(irq); /* make sure it's never delivered */
 		per_cpu(lock_kicker_irq, cpu) = irq;
-		per_cpu(irq_name, cpu) = name;
 	}
 
 	printk("cpu %d spinlock event irq %d\n", cpu, irq);
@@ -104,6 +104,8 @@ void xen_uninit_lock_cpu(int cpu)
 	if (!xen_pvspin)
 		return;
 
+	kfree(per_cpu(irq_name, cpu));
+	per_cpu(irq_name, cpu) = NULL;
 	/*
 	 * When booting the kernel with 'mitigations=auto,nosmt', the secondary
 	 * CPUs are not activated, and lock_kicker_irq is not initialized.
@@ -114,8 +116,6 @@ void xen_uninit_lock_cpu(int cpu)
 
 	unbind_from_irqhandler(irq, NULL);
 	per_cpu(lock_kicker_irq, cpu) = -1;
-	kfree(per_cpu(irq_name, cpu));
-	per_cpu(irq_name, cpu) = NULL;
 }
 
 PV_CALLEE_SAVE_REGS_THUNK(xen_vcpu_stolen);
-- 
2.35.1



