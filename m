Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C690C1AA1B1
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898213AbgDOMpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408995AbgDOLnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159A9206A2;
        Wed, 15 Apr 2020 11:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950999;
        bh=wYLXLG27rnEwhy1UBlgPAvszNrYaMJ0woRo+YuC+rz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i69UK7Vqv9n3w8zsJt4kSYbswKPs/vHJbNbIpdjqJumfWxeP7nub3Bfxrn5DcsUnr
         w36x0iuMlbbIACwKgjtY1AzvcAwkXLK+8jeyDu3HIsmLXaHr0Ix48j/vW+88t3yQdo
         i71BXJqIfTtrMWRGIdk7/V3W3kPVZ0R31lbwdiXM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 045/106] powerpc/prom_init: Pass the "os-term" message to hypervisor
Date:   Wed, 15 Apr 2020 07:41:25 -0400
Message-Id: <20200415114226.13103-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 577345382b23f..673f13b87db13 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1773,6 +1773,9 @@ static void __init prom_rtas_os_term(char *str)
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

