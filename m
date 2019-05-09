Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5056A190A2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfEISrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbfEISrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D9342184C;
        Thu,  9 May 2019 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427628;
        bh=/PDMLp9ytkli3MkNFsgXwaVfR6fjrDOiPBZB0nlmlM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEu6Ur7+mmI3RhsTMgqFTSZgqg5ygcprdBo2r8D2zOO3aa0RXSroY0B0TLP1cVFdD
         N2zaby0xKmLEGJNCCHV1i+QpXePyPYm6HMoeOXRhVcOCPKerJ2DEvULdme87TuAuI7
         7B6yFYyoEDhKw7wKveZ5SGbFjJnb0Hkdyv0M13Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 03/66] Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cleanup()
Date:   Thu,  9 May 2019 20:41:38 +0200
Message-Id: <20190509181302.099188548@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
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
@@ -402,7 +402,6 @@ int hv_synic_cleanup(unsigned int cpu)
 
 		clockevents_unbind_device(hv_cpu->clk_evt, cpu);
 		hv_ce_shutdown(hv_cpu->clk_evt);
-		put_cpu_ptr(hv_cpu);
 	}
 
 	hv_get_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);


