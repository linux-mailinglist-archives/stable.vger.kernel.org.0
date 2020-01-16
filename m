Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BC413EDDC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391045AbgAPSFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393552AbgAPRjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B481C24720;
        Thu, 16 Jan 2020 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196394;
        bh=wU/9PA9pxNxoDXJ6lPoMf6WRbdEvS/5kHPeCbNbXJpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8rYsW0MAtaKoY+mawP7VaIhoNOEifnv4nTRqjh8OG0xlbkg8z/IsggtNtBhLrPg0
         MVRZ5FN2D0W0MGawUFEJKX+2bteNjsIHT+j48Z8P1jdvmu4BhZiSdEZpZntpLeGoaD
         KPwKoxMf9kGWI7ejyWFZIZ/VqHT3O4vsYJqG+AQg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 173/251] x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI
Date:   Thu, 16 Jan 2020 12:35:22 -0500
Message-Id: <20200116173641.22137-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2591bc4e8d70b4e1330d327fb7e3921f4e070a51 ]

apic->send_IPI_allbutself() takes a vector number as argument.

APIC_DM_NMI is clearly not a vector number. It's defined to 0x400 which is
outside the vector space.

Use NMI_VECTOR instead as that's what it is intended to be.

Fixes: 82da3ff89dc2 ("x86: kgdb support")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20190722105218.855189979@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kgdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8e36f249646e..904e18bb38c5 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -438,7 +438,7 @@ static void kgdb_disable_hw_debug(struct pt_regs *regs)
  */
 void kgdb_roundup_cpus(unsigned long flags)
 {
-	apic->send_IPI_allbutself(APIC_DM_NMI);
+	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 #endif
 
-- 
2.20.1

