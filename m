Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459CD1B41D4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgDVKGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgDVKGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F40BD20575;
        Wed, 22 Apr 2020 10:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549996;
        bh=HeZ2js+KmPU0Hq5F3zVKBWufn7QhadTQLVNesgLSsUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzisTLVKcGOrPMb9ti8fz5lWrwYDXvmMnR5MCZj3CfW0DyGtNy7/vJDoKo6TbOBjF
         wg9lDDmKd3wAM8Cwi420OstFRehcW3jXs1n0h0S5vbrjgyAB/CJU0aV67CMypPhixa
         gpMLFqTaGkXDYmTkVTUrIOPVNX5EU7KXKZYjSBrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 055/125] cpufreq: powernv: Fix use-after-free
Date:   Wed, 22 Apr 2020 11:56:12 +0200
Message-Id: <20200422095042.391448899@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

commit d0a72efac89d1c35ac55197895201b7b94c5e6ef upstream.

The cpufreq driver has a use-after-free that we can hit if:

a) There's an OCC message pending when the notifier is registered, and
b) The cpufreq driver fails to register with the core.

When a) occurs the notifier schedules a workqueue item to handle the
message. The backing work_struct is located on chips[].throttle and
when b) happens we clean up by freeing the array. Once we get to
the (now free) queued item and the kernel crashes.

Fixes: c5e29ea7ac14 ("cpufreq: powernv: Fix bugs in powernv_cpufreq_{init/exit}")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200206062622.28235-1-oohall@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/powernv-cpufreq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -955,6 +955,12 @@ static int init_chip_info(void)
 
 static inline void clean_chip_info(void)
 {
+	int i;
+
+	/* flush any pending work items */
+	if (chips)
+		for (i = 0; i < nr_chips; i++)
+			cancel_work_sync(&chips[i].throttle);
 	kfree(chips);
 }
 


