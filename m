Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125A619273
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfEITHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbfEISpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A6C42182B;
        Thu,  9 May 2019 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427538;
        bh=m1pZ22Wjpkk0gzpexI86nF7WYg7MTrOzxz9HapU/iaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EV1l/bTYubAGPHVgmXwT6UO4z300/3Xi7uePXT6MmCBdkrz1i1TZ2guEoqGa4B/zV
         Y8H+HJCiFw7tekBfgQP8C0XRgY2kRvZcNoO3AL4u+tRTQjiENnAKdbrWYEfSVCAP+N
         2Qtfy7CFPfjYE6c6DBUb3/TSdC1irF9ep36QXc7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 02/42] Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cleanup()
Date:   Thu,  9 May 2019 20:41:51 +0200
Message-Id: <20190509181252.944919162@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit a0033bd1eae4650b69be07c17cb87393da584563 upstream.

With CONFIG_DEBUG_PREEMPT=y, the put_cpu_ptr() triggers an underflow
warning in preempt_count_sub().

Fixes: 37cdd991fac8 ("vmbus: put related per-cpu variable together")
Cc: stable@vger.kernel.org
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -356,7 +356,6 @@ int hv_synic_cleanup(unsigned int cpu)
 
 		clockevents_unbind_device(hv_cpu->clk_evt, cpu);
 		hv_ce_shutdown(hv_cpu->clk_evt);
-		put_cpu_ptr(hv_cpu);
 	}
 
 	hv_get_synint_state(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT,


