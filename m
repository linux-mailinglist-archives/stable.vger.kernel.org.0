Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E2F106BD0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfKVKrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbfKVKra (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:47:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C491020718;
        Fri, 22 Nov 2019 10:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419650;
        bh=chzf4IhDLjFrOwKhnx4ivJ8C5s2YcKWi2TRsAL7b7lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUlf0HjPLn7FGXwb9jU3QiyxN/N/0aTxv4wRcvoRq69yZql7Ri/YeEYYJkZZojln+
         IDw4BEQn1HKj85S7OpplZKq+/BVBzQqLdv0wu9VNMgPjRm3xWjuEkTk+PgEX0lREhG
         lkiydBb2h9dPeblGSTUHta0TPXwoCOdVtJbtuPJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 185/222] cpu/SMT: State SMT is disabled even with nosmt and without "=force"
Date:   Fri, 22 Nov 2019 11:28:45 +0100
Message-Id: <20191122100915.700325008@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit d0e7d14455d41163126afecd0fcce935463cc512 ]

When booting with "nosmt=force" a message is issued into dmesg to
confirm that SMT has been force-disabled but such a message is not
issued when only "nosmt" is on the kernel command line.

Fix that.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20181004172227.10094-1-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 0ed3e9deda306..c2573e858009b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -379,6 +379,7 @@ void __init cpu_smt_disable(bool force)
 		pr_info("SMT: Force disabled\n");
 		cpu_smt_control = CPU_SMT_FORCE_DISABLED;
 	} else {
+		pr_info("SMT: disabled\n");
 		cpu_smt_control = CPU_SMT_DISABLED;
 	}
 }
-- 
2.20.1



