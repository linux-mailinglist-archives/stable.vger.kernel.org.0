Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17329106D88
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfKVLAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbfKVLAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C75EB20679;
        Fri, 22 Nov 2019 11:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420451;
        bh=XRvnylUpGzfPdPpjbHa5Bu+gFEj6YjRPwqZH4SaSa+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quF1jZ8gPGmnLr3ofgliwNiaqIhQ1tjZcs7u+12hD8BxlQqbLGm2Sm4UM9WSx/fC3
         6uXw4bdhhq682RxaZcADLPh+cQrMgj84/lFfXqM+IT97jINWZkFbbWDE1myzRwV0dD
         /LBO/K4FMU6GufN+/ICLKfdwYd/nQ6VPodNLibHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/220] cpu/SMT: State SMT is disabled even with nosmt and without "=force"
Date:   Fri, 22 Nov 2019 11:27:55 +0100
Message-Id: <20191122100920.676724471@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
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
index 9bb57ce57d98d..8d6b8b5493f9f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -375,6 +375,7 @@ void __init cpu_smt_disable(bool force)
 		pr_info("SMT: Force disabled\n");
 		cpu_smt_control = CPU_SMT_FORCE_DISABLED;
 	} else {
+		pr_info("SMT: disabled\n");
 		cpu_smt_control = CPU_SMT_DISABLED;
 	}
 }
-- 
2.20.1



