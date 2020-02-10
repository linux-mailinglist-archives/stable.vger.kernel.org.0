Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5841215784A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbgBJNGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgBJMjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:53 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98DBE24650;
        Mon, 10 Feb 2020 12:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338392;
        bh=gxm2KvSy24vJVM6qJ96MO74XGzXAu3rlYDpEdI9euoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zytNYzjkgLPrtcQkxT0RGmke9YHzgf5pL3TZOITqCQssu91zFycKX2k4YolmA97z/
         rOkmfBxRaoGGRzBRYow6vFf0wSEsV/k0mazbyi9Q4uLVyPhZFKpLi69TG3gvQFqknC
         d3lc4k0YwHJua6V/iO5DhT33EvmP7gSFEIuSeOkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.5 085/367] powerpc/xmon: dont access ASDR in VMs
Date:   Mon, 10 Feb 2020 04:29:58 -0800
Message-Id: <20200210122432.199926067@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -1949,15 +1949,14 @@ static void dump_300_sprs(void)
 
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
 


