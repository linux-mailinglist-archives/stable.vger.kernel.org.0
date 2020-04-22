Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8B1B4047
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbgDVKou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbgDVKSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:18:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16CEE2070B;
        Wed, 22 Apr 2020 10:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550714;
        bh=Sql1Qa0q1sxaK1NvXSoxR08DQdz4Luetn7Wwjl1NXMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhML6o2XVeoVh4FKGzw2XqdoxyAzRitLR84ubBbRDFERJxqsWY0qj9Lwg772uYvF8
         4J8Z5DkGb+KR9zEnI5SecHsc8/o8MbyXnU1gYrMCWyD/YT/AGsRLrmAIzmMv7IsCit
         p0ekkD200YkhqAGB4UcAkPypAZTXRNs6GPF4J65M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/118] powerpc/prom_init: Pass the "os-term" message to hypervisor
Date:   Wed, 22 Apr 2020 11:57:04 +0200
Message-Id: <20200422095042.316366295@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 74bb84e5117146fa73eb9d01305975c53022b3c3 ]

The "os-term" RTAS calls has one argument with a message address of OS
termination cause. rtas_os_term() already passes it but the recently
added prom_init's version of that missed it; it also does not fill
args correctly.

This passes the message address and initializes the number of arguments.

Fixes: 6a9c930bd775 ("powerpc/prom_init: Add the ESM call to prom_init")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200312074404.87293-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index eba9d4ee4baf6..689664cd4e79b 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1761,6 +1761,9 @@ static void __init prom_rtas_os_term(char *str)
 	if (token == 0)
 		prom_panic("Could not get token for ibm,os-term\n");
 	os_term_args.token = cpu_to_be32(token);
+	os_term_args.nargs = cpu_to_be32(1);
+	os_term_args.nret = cpu_to_be32(1);
+	os_term_args.args[0] = cpu_to_be32(__pa(str));
 	prom_rtas_hcall((uint64_t)&os_term_args);
 }
 #endif /* CONFIG_PPC_SVM */
-- 
2.20.1



