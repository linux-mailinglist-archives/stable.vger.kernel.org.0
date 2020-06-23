Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542F820603B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391624AbgFWUks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390029AbgFWUks (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:40:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 623AF2053B;
        Tue, 23 Jun 2020 20:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944847;
        bh=bnPlfpzeuiqPJwIdH1SQI2SYIUqtbcha87ZpLA8UBls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZU+E7duCRFGc2RfdAFZCNtWSaaEvTeI3paBjzAacmeZWCyFAXMsNk5ABpA5uz0pc
         6suBBafsklxHfcpT/iSjdjb4y+xH8F/YeK30aqMMV1gvIoNHu2TMcx9AhJNF0swiDT
         ddSmtaRlN35WtIxLGqKO1XtOLSESmmrWnatQFr0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Alexander Fomichev <fomichev.ru@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/206] NTB: perf: Fix support for hardware that doesnt have port numbers
Date:   Tue, 23 Jun 2020 21:57:56 +0200
Message-Id: <20200623195324.275633275@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit b54369a248c2e033bfcf5d6917e08cf9d73d54a6 ]

Legacy drivers do not have port numbers (but is reliably only two ports)
and was broken by the recent commit that added mult-port support to
ntb_perf. This is especially important to support the cross link
topology which is perfectly symmetric and cannot assign unique port
numbers easily.

Hardware that returns zero for both the local port and the peer should
just always use gidx=0 for the only peer.

Fixes: 5648e56d03fa ("NTB: ntb_perf: Add full multi-port NTB API support")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Allen Hubbe <allenbh@gmail.com>
Tested-by: Alexander Fomichev <fomichev.ru@gmail.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 28d288ff3baef..62a9a1d44f9f6 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -1418,6 +1418,16 @@ static int perf_init_peers(struct perf_ctx *perf)
 	if (perf->gidx == -1)
 		perf->gidx = pidx;
 
+	/*
+	 * Hardware with only two ports may not have unique port
+	 * numbers. In this case, the gidxs should all be zero.
+	 */
+	if (perf->pcnt == 1 &&  ntb_port_number(perf->ntb) == 0 &&
+	    ntb_peer_port_number(perf->ntb, 0) == 0) {
+		perf->gidx = 0;
+		perf->peers[0].gidx = 0;
+	}
+
 	for (pidx = 0; pidx < perf->pcnt; pidx++) {
 		ret = perf_setup_peer_mw(&perf->peers[pidx]);
 		if (ret)
-- 
2.25.1



