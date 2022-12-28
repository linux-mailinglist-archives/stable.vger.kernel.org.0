Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3CF65788A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiL1OwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiL1Ov6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:51:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D2B6413
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:51:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E10961365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48EDC433F0;
        Wed, 28 Dec 2022 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239088;
        bh=sjzpE6TxXOaGfUktNUd1mvH/NHxqVsA8dOzS25AlQig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkkFBpG+2rsIRHJ14AWJRLnK7GkZCfZN1UOX7882Z5ShcNLMvNQ0iWyL33AmT97FZ
         8xpCZLYsm+OGCVg3nqXGM4R1vhneuxf0YLfgGrieo+cWmNu1AX0b5bYoXHMv3kRdo9
         ntZXBktxNZUIbqEfVuhT/S29/eEj3fy/nuRjOx4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/731] x86/xen: Fix memory leak in xen_init_lock_cpu()
Date:   Wed, 28 Dec 2022 15:33:51 +0100
Message-Id: <20221228144300.147151070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 043c73dfd2c9..5c6fc16e4b92 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -75,6 +75,7 @@ void xen_init_lock_cpu(int cpu)
 	     cpu, per_cpu(lock_kicker_irq, cpu));
 
 	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
+	per_cpu(irq_name, cpu) = name;
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
 				     dummy_handler,
@@ -85,7 +86,6 @@ void xen_init_lock_cpu(int cpu)
 	if (irq >= 0) {
 		disable_irq(irq); /* make sure it's never delivered */
 		per_cpu(lock_kicker_irq, cpu) = irq;
-		per_cpu(irq_name, cpu) = name;
 	}
 
 	printk("cpu %d spinlock event irq %d\n", cpu, irq);
@@ -98,6 +98,8 @@ void xen_uninit_lock_cpu(int cpu)
 	if (!xen_pvspin)
 		return;
 
+	kfree(per_cpu(irq_name, cpu));
+	per_cpu(irq_name, cpu) = NULL;
 	/*
 	 * When booting the kernel with 'mitigations=auto,nosmt', the secondary
 	 * CPUs are not activated, and lock_kicker_irq is not initialized.
@@ -108,8 +110,6 @@ void xen_uninit_lock_cpu(int cpu)
 
 	unbind_from_irqhandler(irq, NULL);
 	per_cpu(lock_kicker_irq, cpu) = -1;
-	kfree(per_cpu(irq_name, cpu));
-	per_cpu(irq_name, cpu) = NULL;
 }
 
 PV_CALLEE_SAVE_REGS_THUNK(xen_vcpu_stolen);
-- 
2.35.1



