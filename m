Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423AD45C395
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343772AbhKXNkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352808AbhKXNiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D573A6321F;
        Wed, 24 Nov 2021 12:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758569;
        bh=rq6+LjhdFz9npwf8Khl6dyF5fpBEuCbii2vJz+6I5ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/RlTkstLxQ+ggQYLY1tn2I4KAV0nDQFN1L2fccd9wJsHrem4q1x6iPUa98bXnpaA
         zrljnSApEVJ/MbsNoaNzjRPfs2x3n1OiW9yp0tmsieh3LZqr8BH+tFuTBlFBVLSkIf
         lh/Y0ny47t7ZRs17rJcm0etE0RlT/leJVSNyheJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/154] net/smc: Make sure the link_id is unique
Date:   Wed, 24 Nov 2021 12:57:55 +0100
Message-Id: <20211124115704.880993096@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit cf4f5530bb55ef7d5a91036b26676643b80b1616 ]

The link_id is supposed to be unique, but smcr_next_link_id() doesn't
skip the used link_id as expected. So the patch fixes this.

Fixes: 026c381fb477 ("net/smc: introduce link_idx for link group array")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c491dd8e67cda..109d790eaebe2 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -287,13 +287,14 @@ static u8 smcr_next_link_id(struct smc_link_group *lgr)
 	int i;
 
 	while (1) {
+again:
 		link_id = ++lgr->next_link_id;
 		if (!link_id)	/* skip zero as link_id */
 			link_id = ++lgr->next_link_id;
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			if (smc_link_usable(&lgr->lnk[i]) &&
 			    lgr->lnk[i].link_id == link_id)
-				continue;
+				goto again;
 		}
 		break;
 	}
-- 
2.33.0



