Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2135F4D7CC
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFTSKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfFTSKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FE4214AF;
        Thu, 20 Jun 2019 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054243;
        bh=x3DQAm9fBik+KczsyNcMttT72qr4M0hPWQmDCAH5ZlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiTisMHdizKcSos307nWxd6wS2eabA4klcSg+wZbimY+kQvgyuMmylLoBQZDuhXWA
         ajK4aG8LOl0nUQIcaMWwmcxi1xkY3N9TuxEDk2YIB2wyW+BSsnq3EoI99eSJScPkLT
         ArYuTWMHSV/nW2C8CFMgZ3PDQItXcTq+t2Tixjs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavaman Subramaniyam <pavsubra@in.ibm.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/61] powerpc/powernv: Return for invalid IMC domain
Date:   Thu, 20 Jun 2019 19:57:18 +0200
Message-Id: <20190620174341.289176449@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 3d27f02695e4..828f6656f8f7 100644
--- a/arch/powerpc/platforms/powernv/opal-imc.c
+++ b/arch/powerpc/platforms/powernv/opal-imc.c
@@ -161,6 +161,10 @@ static int imc_pmu_create(struct device_node *parent, int pmu_index, int domain)
 	struct imc_pmu *pmu_ptr;
 	u32 offset;
 
+	/* Return for unknown domain */
+	if (domain < 0)
+		return -EINVAL;
+
 	/* memory for pmu */
 	pmu_ptr = kzalloc(sizeof(*pmu_ptr), GFP_KERNEL);
 	if (!pmu_ptr)
-- 
2.20.1



