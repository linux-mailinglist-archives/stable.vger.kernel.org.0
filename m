Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1832C2F502
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfE3Enf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbfE3DMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:10 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60C4624526;
        Thu, 30 May 2019 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185929;
        bh=qWwad4BUKaij/skN+7yXHYUmBvbU4q5h/cwNL4vySvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuMcWRGKixnBWflMx3cnj7R/2G5ZhCdEZMeuZYcZHE1jU0jdZptOIdS0qR1uYCond
         XKWhrO3QtAKbuu85dE3XLWezEb3m0pDBe+Ztf2G+YY82oadX73pPA4vg94S6kD7AO1
         Hi79MTQ+wJmNWxC9tXXOV36kJxMxtY1VqGelf3nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pu Wen <puwen@hygon.cn>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 322/405] x86/CPU/hygon: Fix phys_proc_id calculation logic for multi-die processors
Date:   Wed, 29 May 2019 20:05:20 -0700
Message-Id: <20190530030557.042188802@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e0ceeae708cebf22c990c3d703a4ca187dc837f5 ]

The Hygon family 18h multi-die processor platform supports 1, 2 or
4-Dies per socket. The topology looks like this:

  System View (with 1-Die 2-Socket):
             |------------|
           ------       -----
   SOCKET0 | D0 |       | D1 |  SOCKET1
           ------       -----

  System View (with 2-Die 2-socket):
             --------------------
             |     -------------|------
             |     |            |     |
           ------------       ------------
   SOCKET0 | D1 -- D0 |       | D3 -- D2 | SOCKET1
           ------------       ------------

  System View (with 4-Die 2-Socket) :
             --------------------
             |     -------------|------
             |     |            |     |
           ------------       ------------
           | D1 -- D0 |       | D7 -- D6 |
           | |  \/ |  |       | |  \/ |  |
   SOCKET0 | |  /\ |  |       | |  /\ |  | SOCKET1
           | D2 -- D3 |       | D4 -- D5 |
           ------------       ------------
             |     |            |     |
             ------|------------|     |
                   --------------------

Currently

  phys_proc_id = initial_apicid >> bits

calculates the physical processor ID from the initial_apicid by shifting
*bits*.

However, this does not work for 1-Die and 2-Die 2-socket systems.

According to document [1] section 2.1.11.1, the bits is the value of
CPUID_Fn80000008_ECX[12:15]. The possible values are 4, 5 or 6 which
mean:

  4 - 1 die
  5 - 2 dies
  6 - 3/4 dies.

Hygon programs the initial ApicId the same way as AMD. The ApicId is
read from CPUID_Fn00000001_EBX (see section 2.1.11.1 of referrence [1])
and the definition is as below (see section 2.1.10.2.1.3 of [1]):

      -------------------------------------------------
  Bit |     6     |   5  4  |    3   |    2   1   0   |
      |-----------|---------|--------|----------------|
  IDs | Socket ID | Node ID | CCX ID | Core/Thread ID |
      -------------------------------------------------

So for 3/4-Die configurations, the bits variable is 6, which is the same
as the ApicID definition field.

For 1-Die and 2-Die configurations, bits is 4 or 5, which will cause the
right shifted result to not be exactly the value of socket ID.

However, the socket ID should be obtained from ApicId[6]. To fix the
problem and match the ApicID field definition, set the shift bits to 6
for all Hygon family 18h multi-die CPUs.

Because AMD doesn't have 2-Socket systems with 1-Die/2-Die processors
(see reference [2]), this doesn't need to be changed on the AMD side but
only for Hygon.

[1] https://www.amd.com/system/files/TechDocs/54945_PPR_Family_17h_Models_00h-0Fh.pdf
[2] https://www.amd.com/en/products/specifications/processors

 [bp: heavily massage commit message. ]

Signed-off-by: Pu Wen <puwen@hygon.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1553355740-19999-1-git-send-email-puwen@hygon.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/hygon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index cf25405444ab3..415621ddb8a23 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -19,6 +19,8 @@
 
 #include "cpu.h"
 
+#define APICID_SOCKET_ID_BIT 6
+
 /*
  * nodes_per_socket: Stores the number of nodes per socket.
  * Refer to CPUID Fn8000_001E_ECX Node Identifiers[10:8]
@@ -87,6 +89,9 @@ static void hygon_get_topology(struct cpuinfo_x86 *c)
 		if (!err)
 			c->x86_coreid_bits = get_count_order(c->x86_max_cores);
 
+		/* Socket ID is ApicId[6] for these processors. */
+		c->phys_proc_id = c->apicid >> APICID_SOCKET_ID_BIT;
+
 		cacheinfo_hygon_init_llc_id(c, cpu, node_id);
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
 		u64 value;
-- 
2.20.1



