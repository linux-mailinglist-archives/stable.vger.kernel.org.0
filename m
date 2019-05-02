Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8EC11DC7
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfEBPdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbfEBPc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F9E3204FD;
        Thu,  2 May 2019 15:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811178;
        bh=ScKkV3RlCgegUjZxC97f52fjXHPn9Qxp5wXrr3irFr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtDdgcCPWS3uvaA8dfs3oVFDsfV9yQkfoFF5q2TuqspUeUA93/1AQJQChk5oxTdgd
         s75hFq0wfNf8Hby/jMd6nzYXrkn+Sze9F3fUYNAEBma1rwiOxdWS9w7AxIWzSuCpew
         5NcaxDQREfj0EYv2eMMWOe1HVcnmnZZfFa8QA4aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 072/101] x86/realmode: Dont leak the trampoline kernel address
Date:   Thu,  2 May 2019 17:21:14 +0200
Message-Id: <20190502143344.750930603@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b929a500d68479163c48739d809cbf4c1335db6f ]

Since commit

  ad67b74d2469 ("printk: hash addresses printed with %p")

at boot "____ptrval____" is printed instead of the trampoline addresses:

  Base memory trampoline at [(____ptrval____)] 99000 size 24576

Remove the print as we don't want to leak kernel addresses and this
statement is not needed anymore.

Fixes: ad67b74d2469d9b8 ("printk: hash addresses printed with %p")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190326203046.20787-1-mcroce@redhat.com
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/x86/realmode/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index d10105825d57..47d097946872 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -20,8 +20,6 @@ void __init set_real_mode_mem(phys_addr_t mem, size_t size)
 	void *base = __va(mem);
 
 	real_mode_header = (struct real_mode_header *) base;
-	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       base, (unsigned long long)mem, size);
 }
 
 void __init reserve_real_mode(void)
-- 
2.19.1



