Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5AB66EC6
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfGLMlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbfGLM0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:26:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EDB9208E4;
        Fri, 12 Jul 2019 12:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934363;
        bh=cWPcw6h9DHowQiZYU03G9tXISuDsNEaXKAX0VKfkxiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbwaeTEVEm+4bnADiGuQd4b0Mw6dLzVP3gN4A6znUtqFSP0z9RCUopuOAscDCXkNI
         uHTi1StGK+ySEG61PpuFvJW1aiuFQZNSJIzgTQQzSEf7IBGx4iDzogaIh90LZlTQzf
         Y5dIo2fEWbVbtnJQIXka39ZM+j5Lc9DXANej3wv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 008/138] soc: brcmstb: Fix error path for unsupported CPUs
Date:   Fri, 12 Jul 2019 14:17:52 +0200
Message-Id: <20190712121629.035725171@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 490cad5a3ad6ef0bfd3168a5063140b982f3b22a ]

In case setup_hifcpubiuctrl_regs() returns an error, because of e.g:
an unsupported CPU type, just catch that error and return instead of
blindly continuing with the initialization. This fixes a NULL pointer
de-reference with the code continuing without having a proper array of
registers to use.

Fixes: 22f7a9116eba ("soc: brcmstb: Correct CPU_CREDIT_REG offset for Brahma-B53 CPUs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/brcmstb/biuctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/bcm/brcmstb/biuctrl.c b/drivers/soc/bcm/brcmstb/biuctrl.c
index 6d89ebf13b8a..c16273b31b94 100644
--- a/drivers/soc/bcm/brcmstb/biuctrl.c
+++ b/drivers/soc/bcm/brcmstb/biuctrl.c
@@ -246,7 +246,9 @@ static int __init brcmstb_biuctrl_init(void)
 	if (!np)
 		return 0;
 
-	setup_hifcpubiuctrl_regs(np);
+	ret = setup_hifcpubiuctrl_regs(np);
+	if (ret)
+		return ret;
 
 	ret = mcp_write_pairing_set();
 	if (ret) {
-- 
2.20.1



