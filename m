Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D8B17FCFF
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgCJM55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729842AbgCJM54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A912468E;
        Tue, 10 Mar 2020 12:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845075;
        bh=F4Lhoeop5jyc/HLHpAGZSESF9WLzwH4clZlIidY28eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+WQ9Ih4AzhlXTwZqrmDRaoSKphhcOrQ5ESb/sDIpIBBkSFwjAadmVF1oDU4kJ0hI
         mbWFP2tKj8Usp4nHJrEAG/2XtKuMBY5i4kU28G3XesODIxJAP7AW6Bs/D1bHEWW5YZ
         N2+3gvETL5PWrpxGdrgUASqQrZKe7DeLLIdc1cVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 053/189] csky/smp: Fixup boot failed when CONFIG_SMP
Date:   Tue, 10 Mar 2020 13:38:10 +0100
Message-Id: <20200310123644.900655536@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit c9492737b25ca32679ba3163609d938c9abfd508 ]

If we use a non-ipi-support interrupt controller, it will cause panic here.
We should let cpu up and work with CONFIG_SMP, when we use a non-ipi intc.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/csky/kernel/smp.c b/arch/csky/kernel/smp.c
index b753d382e4cef..0bb0954d55709 100644
--- a/arch/csky/kernel/smp.c
+++ b/arch/csky/kernel/smp.c
@@ -120,7 +120,7 @@ void __init setup_smp_ipi(void)
 	int rc;
 
 	if (ipi_irq == 0)
-		panic("%s IRQ mapping failed\n", __func__);
+		return;
 
 	rc = request_percpu_irq(ipi_irq, handle_ipi, "IPI Interrupt",
 				&ipi_dummy_dev);
-- 
2.20.1



