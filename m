Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FECD14E78
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfEFPCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbfEFOkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7EB21019;
        Mon,  6 May 2019 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153646;
        bh=vLbx+k2n6bZB/VvePRRn0MbYntE5E9JoUOSvqcH+UFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOehVCB+fVmpgehxvVIqn63Ov+A+XeHAjVsVR1Cz1DnJasay0xx5yceiEhR85p6tk
         b8SP9pGa/gl7+pqvdZWV1b7VWeSwR9yP8uMOLqJFcxXls4Wpcb5FtRqA4whk8VWb/l
         WTBg2WA612HDqGbBpH4PMnoLJ1DcxBfwQGRT7ar4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/99] net: stmmac: dont log oversized frames
Date:   Mon,  6 May 2019 16:32:16 +0200
Message-Id: <20190506143057.878602732@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 057a0c5642a2ff2db7c421cdcde34294a23bf37b ]

This is log is harmful as it can trigger multiple times per packet. Delete
it.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index c55a9815b394..b7dd4e3c760d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -91,8 +91,6 @@ static int ndesc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 		return dma_own;
 
 	if (unlikely(!(rdes0 & RDES0_LAST_DESCRIPTOR))) {
-		pr_warn("%s: Oversized frame spanned multiple buffers\n",
-			__func__);
 		stats->rx_length_errors++;
 		return discard_frame;
 	}
-- 
2.20.1



