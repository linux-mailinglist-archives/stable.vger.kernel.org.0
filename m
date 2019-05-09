Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2D719136
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfEISyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbfEISyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E3D420578;
        Thu,  9 May 2019 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428052;
        bh=Kj5Z/o3GPzGUtGgwwDOoGylmwD5Ap/wDMMcXe3t9suE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlIv9XJiMXWRlNGo5CQOjTYla1Lqa6iWPMLsYQday98nSVK/J116piwXMgWehdSmr
         twUjScTEkLZJYpVU3IZ6BrFzSy6WKW8by81p9w7qH/vhUwWMCjWRm1HTMbZ4r4wOCI
         G5wj0gZfrFh1qrfNz3r3mszaJotmjyoLg5tqB71A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.1 01/30] Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cleanup()
Date:   Thu,  9 May 2019 20:42:33 +0200
Message-Id: <20190509181250.759963229@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -408,7 +408,6 @@ int hv_synic_cleanup(unsigned int cpu)
 
 		clockevents_unbind_device(hv_cpu->clk_evt, cpu);
 		hv_ce_shutdown(hv_cpu->clk_evt);
-		put_cpu_ptr(hv_cpu);
 	}
 
 	hv_get_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);


