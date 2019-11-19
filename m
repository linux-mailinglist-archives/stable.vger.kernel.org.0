Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADF61014D6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfKSFhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbfKSFhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D705208C3;
        Tue, 19 Nov 2019 05:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141874;
        bh=NBNBvP45RE2ewafMBBNQHhDvHIX7XZ6vY2f8zsAHmcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMCrZCxwr7BBgmMfo7ztRc8ooh3wIuH5GAw9HqSsurNSlPT5/AWiFSEAEEN1+6mRJ
         JzDmtLDDfgZbusYACLbbZsO7Fla6adBgVl0ufSl+zdazJd27heWiD9nI30hy5HD1cM
         Wiklf+pbCpbesmBJFZhyK39vkm7CK2yVc6YeN2Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 308/422] x86/mce-inject: Reset injection struct after injection
Date:   Tue, 19 Nov 2019 06:18:25 +0100
Message-Id: <20191119051418.957799948@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 7401a633c34adc7aefd3edfec60074cb0475a3e8 ]

Clear the MCE struct which is used for collecting the injection details
after injection.

Also, populate it with more details from the machine.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20180905081954.10391-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index ff1c00b695aed..1ceccc4a5472c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -106,6 +106,9 @@ static void setup_inj_struct(struct mce *m)
 	memset(m, 0, sizeof(struct mce));
 
 	m->cpuvendor = boot_cpu_data.x86_vendor;
+	m->time	     = ktime_get_real_seconds();
+	m->cpuid     = cpuid_eax(1);
+	m->microcode = boot_cpu_data.microcode;
 }
 
 /* Update fake mce registers on current CPU. */
@@ -580,6 +583,9 @@ static int inj_bank_set(void *data, u64 val)
 	m->bank = val;
 	do_inject();
 
+	/* Reset injection struct */
+	setup_inj_struct(&i_mce);
+
 	return 0;
 }
 
-- 
2.20.1



