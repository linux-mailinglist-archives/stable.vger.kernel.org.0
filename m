Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF543396261
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhEaOzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232601AbhEaOxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1FD61440;
        Mon, 31 May 2021 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469535;
        bh=DfZKl/NzFi7lgZuQmVDSRGUm2tklNb+SYAcydYSVrD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wyhn2UapMRXRiXTHZr2L1X3oyr9p1LlWx8uX8COseAsT/eufqMEdCSttonry2hvMa
         jo3WVCk4QZ9avTpAR3LRB6/B4UC50jnK0bJgYilsBOHgWRlI2bj8a6WlYg74461V3N
         9bkWrVWgwxGXFxhG/z3VH6D8mmhBU3SnMRYOz2Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 234/296] octeontx2-pf: fix a buffer overflow in otx2_set_rxfh_context()
Date:   Mon, 31 May 2021 15:14:49 +0200
Message-Id: <20210531130711.670263034@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e5cc361e21648b75f935f9571d4003aaee480214 ]

This function is called from ethtool_set_rxfh() and "*rss_context"
comes from the user.  Add some bounds checking to prevent memory
corruption.

Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index f4962a97a075..9d9a2e438acf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -786,6 +786,10 @@ static int otx2_set_rxfh_context(struct net_device *dev, const u32 *indir,
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
 
+	if (*rss_context != ETH_RXFH_CONTEXT_ALLOC &&
+	    *rss_context >= MAX_RSS_GROUPS)
+		return -EINVAL;
+
 	rss = &pfvf->hw.rss_info;
 
 	if (!rss->enable) {
-- 
2.30.2



