Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914289E17A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfH0H7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731169AbfH0H7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84196206BA;
        Tue, 27 Aug 2019 07:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892757;
        bh=K3sUxwuK4U/+xieBaB5p/JucqXzHSKvpmUsQVWuCUMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLWn0hU74Ut61rhRt7d/IVkZ/LlHn5hXciZ2SsK7VCFaCihiYXosWfZ804l2NZWXO
         A6xvhi+Ef2edF/pQZlw+gRprpivrDiLRFIdrhl8ljmPqiahwnJumMNra8ZXoV+G1+u
         hwKSuR2/rEpwTRxpZDT6ti5ovqKpXj3piBg8Xu/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/98] x86/lib/cpu: Address missing prototypes warning
Date:   Tue, 27 Aug 2019 09:50:29 +0200
Message-Id: <20190827072720.952397795@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 04f5bda84b0712d6f172556a7e8dca9ded5e73b9 ]

When building with W=1, warnings about missing prototypes are emitted:

  CC      arch/x86/lib/cpu.o
arch/x86/lib/cpu.c:5:14: warning: no previous prototype for 'x86_family' [-Wmissing-prototypes]
    5 | unsigned int x86_family(unsigned int sig)
      |              ^~~~~~~~~~
arch/x86/lib/cpu.c:18:14: warning: no previous prototype for 'x86_model' [-Wmissing-prototypes]
   18 | unsigned int x86_model(unsigned int sig)
      |              ^~~~~~~~~
arch/x86/lib/cpu.c:33:14: warning: no previous prototype for 'x86_stepping' [-Wmissing-prototypes]
   33 | unsigned int x86_stepping(unsigned int sig)
      |              ^~~~~~~~~~~~

Add the proper include file so the prototypes are there.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/42513.1565234837@turing-police
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/lib/cpu.c b/arch/x86/lib/cpu.c
index 2dd1fe13a37b3..19f707992db22 100644
--- a/arch/x86/lib/cpu.c
+++ b/arch/x86/lib/cpu.c
@@ -1,5 +1,6 @@
 #include <linux/types.h>
 #include <linux/export.h>
+#include <asm/cpu.h>
 
 unsigned int x86_family(unsigned int sig)
 {
-- 
2.20.1



