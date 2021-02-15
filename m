Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5331BD1A
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhBOPkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231479AbhBOPhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9405064EA7;
        Mon, 15 Feb 2021 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403197;
        bh=GZTzwpC31F6WXnAiRavxsqhcbOW5d1H/w3YO1vV4c5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2I6YIcbgcgMBron3e+IXN5hGGTXCaI7TJPM0nO0PaGIybGOSU8zua037wX7E8/r8
         emAyP2e2bjVtjvtmTYFnyh8x0lG9VgmdxnUndXsGim4cLauOvTHZH+6S78mRjAZCwd
         IXJXWRIwr/Q0sUFRCtgGaAerNti9eTFZnKTA8q9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/104] hv_netvsc: Reset the RSC count if NVSP_STAT_FAIL in netvsc_receive()
Date:   Mon, 15 Feb 2021 16:27:17 +0100
Message-Id: <20210215152721.540604376@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

[ Upstream commit 12bc8dfb83b5292fe387b795210018b7632ee08b ]

Commit 44144185951a0f ("hv_netvsc: Add validation for untrusted Hyper-V
values") added validation to rndis_filter_receive_data() (and
rndis_filter_receive()) which introduced NVSP_STAT_FAIL-scenarios where
the count is not updated/reset.  Fix this omission, and prevent similar
scenarios from occurring in the future.

Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Fixes: 44144185951a0f ("hv_netvsc: Add validation for untrusted Hyper-V values")
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/20210203113602.558916-1-parri.andrea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c       | 5 ++++-
 drivers/net/hyperv/rndis_filter.c | 2 --
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 0c3de94b51787..6a7ab930ef70d 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1253,8 +1253,11 @@ static int netvsc_receive(struct net_device *ndev,
 		ret = rndis_filter_receive(ndev, net_device,
 					   nvchan, data, buflen);
 
-		if (unlikely(ret != NVSP_STAT_SUCCESS))
+		if (unlikely(ret != NVSP_STAT_SUCCESS)) {
+			/* Drop incomplete packet */
+			nvchan->rsc.cnt = 0;
 			status = NVSP_STAT_FAIL;
+		}
 	}
 
 	enq_receive_complete(ndev, net_device, q_idx,
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index b22e47bcfeca1..90bc0008fa2fd 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -508,8 +508,6 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 	return ret;
 
 drop:
-	/* Drop incomplete packet */
-	nvchan->rsc.cnt = 0;
 	return NVSP_STAT_FAIL;
 }
 
-- 
2.27.0



