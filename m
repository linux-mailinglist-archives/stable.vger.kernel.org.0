Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E64346279F
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbhK2XIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbhK2XHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD03AC047CF4;
        Mon, 29 Nov 2021 10:31:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63627B815E5;
        Mon, 29 Nov 2021 18:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF8FC53FCF;
        Mon, 29 Nov 2021 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210712;
        bh=k5NqmFu/VN1F8jKjgxVZHYdhIZ9okSEeF583AuLr9+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaezNGVEc0Lwux7CjN/La4n7CjUwKAa8lgjRUN0C8KJa2WiMrde1cSHHN+X2YDGLl
         m3GNua1ok44TXRqvf0CUs76NC9ISqzTl3GsT7jvkaAeRzHfBwL2ZgntS43dLsB/lKK
         nxJ4ZdtHct9ep6brM5Y2eNB6OEfgY+jLQ8IscBsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Danielle Ratson <danieller@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/121] igb: fix netpoll exit with traffic
Date:   Mon, 29 Nov 2021 19:18:41 +0100
Message-Id: <20211129181714.690528004@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit eaeace60778e524a2820d0c0ad60bf80289e292c ]

Oleksandr brought a bug report where netpoll causes trace
messages in the log on igb.

Danielle brought this back up as still occurring, so we'll try
again.

[22038.710800] ------------[ cut here ]------------
[22038.710801] igb_poll+0x0/0x1440 [igb] exceeded budget in poll
[22038.710802] WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155 netpoll_poll_dev+0x18a/0x1a0

As Alex suggested, change the driver to return work_done at the
exit of napi_poll, which should be safe to do in this driver
because it is not polling multiple queues in this single napi
context (multiple queues attached to one MSI-X vector). Several
other drivers contain the same simple sequence, so I hope
this will not create new problems.

Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead and improve performance")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reported-by: Danielle Ratson <danieller@nvidia.com>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Danielle Ratson <danieller@nvidia.com>
Link: https://lore.kernel.org/r/20211123204000.1597971-1-jesse.brandeburg@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e24fb122c03a2..d5432d1448c05 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8032,7 +8032,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
 	if (likely(napi_complete_done(napi, work_done)))
 		igb_ring_irq_enable(q_vector);
 
-	return min(work_done, budget - 1);
+	return work_done;
 }
 
 /**
-- 
2.33.0



