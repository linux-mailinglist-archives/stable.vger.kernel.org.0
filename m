Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768281566DF
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBHShf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:37:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33798 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727764AbgBHS3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:39 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dR-8T; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CLj-0o; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Thierry Reding" <treding@nvidia.com>,
        "Dmitry Osipenko" <digetx@gmail.com>
Date:   Sat, 08 Feb 2020 18:19:40 +0000
Message-ID: <lsq.1581185940.700341129@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 041/148] ARM: tegra: Fix FLOW_CTLR_HALT register
 clobbering by tegra_resume()
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <digetx@gmail.com>

commit d70f7d31a9e2088e8a507194354d41ea10062994 upstream.

There is an unfortunate typo in the code that results in writing to
FLOW_CTLR_HALT instead of FLOW_CTLR_CSR.

Acked-by: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-tegra/reset-handler.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -55,16 +55,16 @@ ENTRY(tegra_resume)
 	cmp	r6, #TEGRA20
 	beq	1f				@ Yes
 	/* Clear the flow controller flags for this CPU. */
-	cpu_to_csr_reg r1, r0
+	cpu_to_csr_reg r3, r0
 	mov32	r2, TEGRA_FLOW_CTRL_BASE
-	ldr	r1, [r2, r1]
+	ldr	r1, [r2, r3]
 	/* Clear event & intr flag */
 	orr	r1, r1, \
 		#FLOW_CTRL_CSR_INTR_FLAG | FLOW_CTRL_CSR_EVENT_FLAG
 	movw	r0, #0x3FFD	@ enable, cluster_switch, immed, bitmaps
 				@ & ext flags for CPU power mgnt
 	bic	r1, r1, r0
-	str	r1, [r2]
+	str	r1, [r2, r3]
 1:
 
 	mov32	r9, 0xc09

