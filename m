Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEAA26F46
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbfEVTY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731271AbfEVTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:24:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E91B2217D4;
        Wed, 22 May 2019 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553064;
        bh=ydUlpHLDPMMW07hp5RBCGFt/Sec4pIdFGpss3PWtDUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+u1/ulUdew317N1Eoa2/fJQvh/+RTAH8PvrUQwmpBD0TpWSeLDCmkuZZcxkNfbTx
         eCpx3xTGA21mImglasGa3sb/cMHvFquyXdF88hwRO4O6gwgyOP49yFXXpueyPoLju1
         CTdsQNmiaGI8akRGU8fAtrQobwjBiZVSb1DB6dFo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.0 029/317] powerpc/perf: Return accordingly on invalid chip-id in
Date:   Wed, 22 May 2019 15:18:50 -0400
Message-Id: <20190522192338.23715-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anju T Sudhakar <anju@linux.vnet.ibm.com>

[ Upstream commit a913e5e8b43be1d3897a141ce61c1ec071cad89c ]

Nest hardware counter memory resides in a per-chip reserve-memory.
During nest_imc_event_init(), chip-id of the event-cpu is considered to
calculate the base memory addresss for that cpu. Return, proper error
condition if the chip_id calculated is invalid.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 885dcd709ba91 ("powerpc/perf: Add nest IMC PMU support")
Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/imc-pmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index f292a3f284f1c..4f34c7557bdb7 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -496,6 +496,11 @@ static int nest_imc_event_init(struct perf_event *event)
 	 * Get the base memory addresss for this cpu.
 	 */
 	chip_id = cpu_to_chip_id(event->cpu);
+
+	/* Return, if chip_id is not valid */
+	if (chip_id < 0)
+		return -ENODEV;
+
 	pcni = pmu->mem_info;
 	do {
 		if (pcni->id == chip_id) {
-- 
2.20.1

