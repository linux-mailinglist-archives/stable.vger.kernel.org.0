Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084ED1AC891
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408552AbgDPNuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408483AbgDPNud (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0184A20786;
        Thu, 16 Apr 2020 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045033;
        bh=LoTfbwCSaBF2QyTddDg0v6TEKT+rRRwgXkOpkMtXQUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDuEivrg5fJCLSfTP+XhiQ/52wMgMkfoZP2yEkVf9e7j63pJ8S6HRUAhbCTA+AyEt
         yA+fTWjBYcRjxeQQBzypobmityNCNZyTaN2xVRixUFofjfd4Kj5gAVwTxg4KcLcqpo
         ZCQ3q0Rbwnn29S0MVM6HIRb9TBViXiWBqbHd5rAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 202/232] cpufreq: powernv: Fix use-after-free
Date:   Thu, 16 Apr 2020 15:24:56 +0200
Message-Id: <20200416131340.542488976@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
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
@@ -1080,6 +1080,12 @@ free_and_return:
 
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
 


