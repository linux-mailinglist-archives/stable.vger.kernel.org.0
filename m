Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BF4461F45
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380100AbhK2Sp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380259AbhK2SnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59655B815C5;
        Mon, 29 Nov 2021 18:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84450C53FAD;
        Mon, 29 Nov 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211205;
        bh=MG1Yf1Gik9hQKxESksFmltQTtVwc8uUr1Drh14KDg3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLCMlg+DWRzkR6oJmHfrc5Szn+b3eb/UAZccMJEE7YnGwt2IT2TNqxzKC9tX1Uh8y
         f3VW21yjq/xFzfzEvxIW0wLLKOFizIyYckpzlIJeUix2eMhYFTrJ2u7MC5j6CRBMNa
         v6387pjUkedOL5tKTBgcZ2A03qCy1Nci1XO/iIlo=
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
Subject: [PATCH 5.15 140/179] igb: fix netpoll exit with traffic
Date:   Mon, 29 Nov 2021 19:18:54 +0100
Message-Id: <20211129181723.554788331@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index 751de06019a0e..8f30577386b6f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8019,7 +8019,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
 	if (likely(napi_complete_done(napi, work_done)))
 		igb_ring_irq_enable(q_vector);
 
-	return min(work_done, budget - 1);
+	return work_done;
 }
 
 /**
-- 
2.33.0



