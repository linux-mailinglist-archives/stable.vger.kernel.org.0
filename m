Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F432E66D6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgL1QRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731502AbgL1NRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:17:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C18E7207C9;
        Mon, 28 Dec 2020 13:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161386;
        bh=flFALhujOsQ/SdUfxgVQE78tjaNosgiy4sL9SMFY8oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntS1r7dZiAvFy+He3D93PjcT+7kVxCtNyvCR6+E5zGrElmobVOYcG7HLFcI+aJh3H
         LXM6KZhihNbfoPfSXJS7+vH+BJKI44qYP9x+uBSveYPPoWvbPZhCUSFeYNsEuVcde/
         AgrjI1jc3yQFwgDj0pBcJTR//JSSUmjl5hqim+eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 196/242] powerpc/perf: Exclude kernel samples while counting events in user space.
Date:   Mon, 28 Dec 2020 13:50:01 +0100
Message-Id: <20201228124914.329789714@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
@@ -2068,6 +2068,16 @@ static void record_and_restart(struct pe
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


