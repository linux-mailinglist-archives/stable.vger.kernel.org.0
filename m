Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC021CAF69
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgEHNRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgEHMns (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF9420720;
        Fri,  8 May 2020 12:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941827;
        bh=JxyaVjjFyzw3AEu5ORR/zDEFaxtWMS0F539DVma9a6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQ8GMrgixI1dJ3xOiuGKFBmbQUzd+YZPrmzjzhpDL85GzQv3D8BW2wb3DckRWitg8
         gwZvavuIHX9PCS/5vTg7yyAfSTWnQT80jSrYjdsTws1dC3rtu3MYXfmDxHN2mSYFRV
         FOKOHfHeBuqSVBg+GWbUuJsgsmMebiE/4deGAYgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 148/312] powerpc/book3s: Fix MCE console messages for unrecoverable MCE.
Date:   Fri,  8 May 2020 14:32:19 +0200
Message-Id: <20200508123134.870052137@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

commit c74dd88e77d3ecbc9e55c78796d82c9aa21cabad upstream.

When machine check occurs with MSR(RI=0), it means MC interrupt is
unrecoverable and kernel goes down to panic path. But the console
message still shows it as recovered. This patch fixes the MCE console
messages.

Fixes: 36df96f8acaf ("powerpc/book3s: Decode and save machine check event.")
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/mce.c             |    3 ++-
 arch/powerpc/platforms/powernv/opal.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -92,7 +92,8 @@ void save_mce_event(struct pt_regs *regs
 	mce->in_use = 1;
 
 	mce->initiator = MCE_INITIATOR_CPU;
-	if (handled)
+	/* Mark it recovered if we have handled it and MSR(RI=1). */
+	if (handled && (regs->msr & MSR_RI))
 		mce->disposition = MCE_DISPOSITION_RECOVERED;
 	else
 		mce->disposition = MCE_DISPOSITION_NOT_RECOVERED;
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -401,6 +401,7 @@ static int opal_recover_mce(struct pt_re
 
 	if (!(regs->msr & MSR_RI)) {
 		/* If MSR_RI isn't set, we cannot recover */
+		pr_err("Machine check interrupt unrecoverable: MSR(RI=0)\n");
 		recovered = 0;
 	} else if (evt->disposition == MCE_DISPOSITION_RECOVERED) {
 		/* Platform corrected itself */


