Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3467F2FA3F5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389967AbhARLmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388207AbhARLmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C780722CF6;
        Mon, 18 Jan 2021 11:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970101;
        bh=4SfJdloB45KTxytxtJ2ZFq4iDMuLZiL5ji8CUdcueb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxdSNGEYP5YwD7QnvRxY6FgRTeIzNeLaMhzIkGzYLc5OkEUjdwO38JvIIFUn+Gdka
         JpqJFAO3W16OPyLR3OpvF1w2W6TR7onnrrUu7X1KAyqcEyiMIGQ7Wczj7s6b6nspRK
         bG6PQ7PFnz6VmhY5s8uG4qy6+H74Er8p+IcGAtz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        stable@kernel.org, Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 5.10 007/152] x86/hyperv: check cpu mask after interrupt has been disabled
Date:   Mon, 18 Jan 2021 12:33:02 +0100
Message-Id: <20210118113353.117595762@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Liu <wei.liu@kernel.org>

commit ad0a6bad44758afa3b440c254a24999a0c7e35d5 upstream.

We've observed crashes due to an empty cpu mask in
hyperv_flush_tlb_others.  Obviously the cpu mask in question is changed
between the cpumask_empty call at the beginning of the function and when
it is actually used later.

One theory is that an interrupt comes in between and a code path ends up
changing the mask. Move the check after interrupt has been disabled to
see if it fixes the issue.

Signed-off-by: Wei Liu <wei.liu@kernel.org>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20210105175043.28325-1-wei.liu@kernel.org
Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/hyperv/mmu.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -66,11 +66,17 @@ static void hyperv_flush_tlb_others(cons
 	if (!hv_hypercall_pg)
 		goto do_native;
 
-	if (cpumask_empty(cpus))
-		return;
-
 	local_irq_save(flags);
 
+	/*
+	 * Only check the mask _after_ interrupt has been disabled to avoid the
+	 * mask changing under our feet.
+	 */
+	if (cpumask_empty(cpus)) {
+		local_irq_restore(flags);
+		return;
+	}
+
 	flush_pcpu = (struct hv_tlb_flush **)
 		     this_cpu_ptr(hyperv_pcpu_input_arg);
 


