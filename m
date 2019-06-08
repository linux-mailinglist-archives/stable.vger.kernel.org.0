Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F05B39EEA
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfFHLrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbfFHLrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:47:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 451A0214DA;
        Sat,  8 Jun 2019 11:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994428;
        bh=pn3uXfupcXHKnHLZP5by70hUfubirNwEj62JCf/QL5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RN37rsbO2EOlfIKl65i6moNjtdczYVHVpq6aMIyyK/YKZs6llnySvypYrE9zb3wr4
         AcTIrU2YYtZ2UtQSElG70U8LkIrnG6UmWupWet0z8MSTGBzd5EyHytxk+2qSF1ELSM
         8CA76lAMsnv+hyh4e8fEgMgIAzLTyQJ7qLy6C1Oc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Pavaman Subramaniyam <pavsubra@in.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 07/31] powerpc/powernv: Return for invalid IMC domain
Date:   Sat,  8 Jun 2019 07:46:18 -0400
Message-Id: <20190608114646.9415-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114646.9415-1-sashal@kernel.org>
References: <20190608114646.9415-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anju T Sudhakar <anju@linux.vnet.ibm.com>

[ Upstream commit b59bd3527fe3c1939340df558d7f9d568fc9f882 ]

Currently init_imc_pmu() can fail either because we try to register an
IMC unit with an invalid domain (i.e an IMC node not supported by the
kernel) or something went wrong while registering a valid IMC unit. In
both the cases kernel provides a 'Register failed' error message.

For example when trace-imc node is not supported by the kernel, but
skiboot advertises a trace-imc node we print:

  IMC Unknown Device type
  IMC PMU (null) Register failed

To avoid confusion just print the unknown device type message, before
attempting PMU registration, so the second message isn't printed.

Fixes: 8f95faaac56c ("powerpc/powernv: Detect and create IMC device")
Reported-by: Pavaman Subramaniyam <pavsubra@in.ibm.com>
Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
[mpe: Reword change log a bit]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-imc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal-imc.c b/arch/powerpc/platforms/powernv/opal-imc.c
index 6914b289c86b..7b93191dc2e3 100644
--- a/arch/powerpc/platforms/powernv/opal-imc.c
+++ b/arch/powerpc/platforms/powernv/opal-imc.c
@@ -87,6 +87,10 @@ static int imc_pmu_create(struct device_node *parent, int pmu_index, int domain)
 	struct imc_pmu *pmu_ptr;
 	u32 offset;
 
+	/* Return for unknown domain */
+	if (domain < 0)
+		return -EINVAL;
+
 	/* memory for pmu */
 	pmu_ptr = kzalloc(sizeof(struct imc_pmu), GFP_KERNEL);
 	if (!pmu_ptr)
-- 
2.20.1

