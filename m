Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D499498ED4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345734AbiAXTsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354102AbiAXTlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:41:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA695C061747;
        Mon, 24 Jan 2022 11:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F059B8121A;
        Mon, 24 Jan 2022 19:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE29C340E5;
        Mon, 24 Jan 2022 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052049;
        bh=2Ao0xJWtEm824Wm0cz0zDXdrq9k9TSs5nYnz5dAhi+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJN1icgo+P5z+WxTW0jT9IHg3pz+fYqnCwn7DpPgZ9R2KFguKDu6fR1g4T87S53wl
         ngpLzmAAN8A5KCEcdxCyWu8NZt/0k8kZXfpyyAZrSZKeFD/3TLk7rlmCF2QevwL67l
         vipLu/hHuej7s+7mhFpb2TTd1bgSDhRGrr1LpQls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/239] x86/mce: Mark mce_read_aux() noinstr
Date:   Mon, 24 Jan 2022 19:43:02 +0100
Message-Id: <20220124183947.676611681@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 26adaad3f2587..8f36ccf26ceca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -651,7 +651,7 @@ static struct notifier_block mce_default_nb = {
 /*
  * Read ADDR and MISC registers.
  */
-static void mce_read_aux(struct mce *m, int i)
+static noinstr void mce_read_aux(struct mce *m, int i)
 {
 	if (m->status & MCI_STATUS_MISCV)
 		m->misc = mce_rdmsrl(msr_ops.misc(i));
-- 
2.34.1



