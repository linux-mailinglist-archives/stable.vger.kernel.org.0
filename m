Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE742E4306
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407430AbgL1NyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407426AbgL1NyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1719E20731;
        Mon, 28 Dec 2020 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163645;
        bh=kDeyWoOTSIi6e2FPwv9y7pptJVbrcPiTxTn3WalqPg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9IF/0q0doE8TGH0c0UkBbFNgWo4Bi31PBo3ug7IQXB3hG+FEuqwv39tSimOf54WV
         mPHTxKeMxy1zaIYslwGCjENrdSWIsWumM6RTb1t2UIaPdDrmshp/yTW1Gka/En1f3r
         HslamLWf+76YmfC/5GuuoVsl5OPLl8iIMovC6i1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 358/453] powerpc/perf: Exclude kernel samples while counting events in user space.
Date:   Mon, 28 Dec 2020 13:49:54 +0100
Message-Id: <20201228124954.435901547@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

commit aa8e21c053d72b6639ea5a7f1d3a1d0209534c94 upstream.

Perf event attritube supports exclude_kernel flag to avoid
sampling/profiling in supervisor state (kernel). Based on this event
attr flag, Monitor Mode Control Register bit is set to freeze on
supervisor state. But sometimes (due to hardware limitation), Sampled
Instruction Address Register (SIAR) locks on to kernel address even
when freeze on supervisor is set. Patch here adds a check to drop
those samples.

Cc: stable@vger.kernel.org
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1606289215-1433-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/core-book3s.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2090,6 +2090,16 @@ static void record_and_restart(struct pe
 	perf_event_update_userpage(event);
 
 	/*
+	 * Due to hardware limitation, sometimes SIAR could sample a kernel
+	 * address even when freeze on supervisor state (kernel) is set in
+	 * MMCR2. Check attr.exclude_kernel and address to drop the sample in
+	 * these cases.
+	 */
+	if (event->attr.exclude_kernel && record)
+		if (is_kernel_addr(mfspr(SPRN_SIAR)))
+			record = 0;
+
+	/*
 	 * Finally record data if requested.
 	 */
 	if (record) {


