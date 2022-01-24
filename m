Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CD349A3CA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368802AbiAYAAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846526AbiAXXQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2389CC0617BA;
        Mon, 24 Jan 2022 13:25:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0EAFB80FA1;
        Mon, 24 Jan 2022 21:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0960DC340E7;
        Mon, 24 Jan 2022 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059524;
        bh=6wrrJ7aDxIrQw2TbOvBal/FrCaDdQi8ycw415kthYKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXBzi/AD4nBmViT04kMQ71g/g10lNhLJo3+T3ikECaW88oYsTWh27GwhpccalZfhA
         xr0SLaC8gxIxbqIRYzQGfjzKmpUW2u3TQ0+awzh4N2qCHTC/SSR76pFYroCzyMiZ4Z
         pHIZHQ0V21voyOrQZF3s397fdJHje5FqpTxfIkHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0644/1039] x86/mce: Mark mce_read_aux() noinstr
Date:   Mon, 24 Jan 2022 19:40:33 +0100
Message-Id: <20220124184147.005035525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit db6c996d6ce45dfb44891f0824a65ecec216f47a ]

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0x681: call to mce_read_aux() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-10-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 75095986e5eff..69fd51a29278f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -645,7 +645,7 @@ static struct notifier_block mce_default_nb = {
 /*
  * Read ADDR and MISC registers.
  */
-static void mce_read_aux(struct mce *m, int i)
+static noinstr void mce_read_aux(struct mce *m, int i)
 {
 	if (m->status & MCI_STATUS_MISCV)
 		m->misc = mce_rdmsrl(mca_msr_reg(i, MCA_MISC));
-- 
2.34.1



