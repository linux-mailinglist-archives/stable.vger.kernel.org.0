Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332F8157A8B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgBJMhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbgBJMhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:12 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5F720733;
        Mon, 10 Feb 2020 12:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338232;
        bh=r6ZSEKAcPOGSCgVBKU4Kqbfz3ie67Rtztmpje+wDHlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmT6NqYzHVrJ7YaeNxV3hEBW9Pddhp8emq9fqI6YMuGsDqFBu8f8IJI90C/0EYTi9
         pjusdk7mi+329ByZB4KO1gPx24uDEU7setiFVASuz8lKVtERKtDQH2z0ylmkiguGP1
         mc65flLBq5PiYUjxdhTfDNGpKCtcabGgb0l+IWJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 076/309] powerpc/xmon: dont access ASDR in VMs
Date:   Mon, 10 Feb 2020 04:30:32 -0800
Message-Id: <20200210122413.155402391@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

commit c2a20711fc181e7f22ee5c16c28cb9578af84729 upstream.

ASDR is HV-privileged and must only be accessed in HV-mode.
Fixes a Program Check (0x700) when xmon in a VM dumps SPRs.

Fixes: d1e1b351f50f ("powerpc/xmon: Add ISA v3.0 SPRs to SPR dump")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200107021633.GB29843@us.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/xmon/xmon.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1894,15 +1894,14 @@ static void dump_300_sprs(void)
 
 	printf("pidr   = %.16lx  tidr  = %.16lx\n",
 		mfspr(SPRN_PID), mfspr(SPRN_TIDR));
-	printf("asdr   = %.16lx  psscr = %.16lx\n",
-		mfspr(SPRN_ASDR), hv ? mfspr(SPRN_PSSCR)
-					: mfspr(SPRN_PSSCR_PR));
+	printf("psscr  = %.16lx\n",
+		hv ? mfspr(SPRN_PSSCR) : mfspr(SPRN_PSSCR_PR));
 
 	if (!hv)
 		return;
 
-	printf("ptcr   = %.16lx\n",
-		mfspr(SPRN_PTCR));
+	printf("ptcr   = %.16lx  asdr  = %.16lx\n",
+		mfspr(SPRN_PTCR), mfspr(SPRN_ASDR));
 #endif
 }
 


