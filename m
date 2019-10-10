Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9EBD23E6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbfJJIrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389427AbfJJIrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F0492064A;
        Thu, 10 Oct 2019 08:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697225;
        bh=dnGqd1ObimZ3Tr3PDaMcwB52h2ie1S30jPgAz+CwwGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHnMvRKdtAiA/KYVdBSEc1Ilm/bnoCAjCAtMNjt50TXY7g5Jos5S2P3EiPup3OUki
         +wFIXqmKwAUqlvK1JhhlmfxS3Qo7LWvqiLjRBcoujKf3KvTllEs8x1sm/zmycoGWze
         mxvWid8/Wqu5MjyS3cl2ggMYRZZ/r0w4cngPR8As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay R Mehta <sanju.mehta@amd.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/114] ntb: point to right memory window index
Date:   Thu, 10 Oct 2019 10:36:11 +0200
Message-Id: <20191010083610.088719432@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanjay R Mehta <sanju.mehta@amd.com>

[ Upstream commit ae89339b08f3fe02457ec9edd512ddc3d246d0f8 ]

second parameter of ntb_peer_mw_get_addr is pointing to wrong memory
window index by passing "peer gidx" instead of "local gidx".

For ex, "local gidx" value is '0' and "peer gidx" value is '1', then

on peer side ntb_mw_set_trans() api is used as below with gidx pointing to
local side gidx which is '0', so memroy window '0' is chosen and XLAT '0'
will be programmed by peer side.

    ntb_mw_set_trans(perf->ntb, peer->pidx, peer->gidx, peer->inbuf_xlat,
                    peer->inbuf_size);

Now, on local side ntb_peer_mw_get_addr() is been used as below with gidx
pointing to "peer gidx" which is '1', so pointing to memory window '1'
instead of memory window '0'.

    ntb_peer_mw_get_addr(perf->ntb,  peer->gidx, &phys_addr,
                        &peer->outbuf_size);

So this patch pass "local gidx" as parameter to ntb_peer_mw_get_addr().

Signed-off-by: Sanjay R Mehta <sanju.mehta@amd.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 2a9d6b0d1f193..80508da3c8b5c 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -1373,7 +1373,7 @@ static int perf_setup_peer_mw(struct perf_peer *peer)
 	int ret;
 
 	/* Get outbound MW parameters and map it */
-	ret = ntb_peer_mw_get_addr(perf->ntb, peer->gidx, &phys_addr,
+	ret = ntb_peer_mw_get_addr(perf->ntb, perf->gidx, &phys_addr,
 				   &peer->outbuf_size);
 	if (ret)
 		return ret;
-- 
2.20.1



