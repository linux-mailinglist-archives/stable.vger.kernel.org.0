Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8122B3962AD
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhEaPAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231585AbhEaO5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4155F61402;
        Mon, 31 May 2021 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469617;
        bh=e9Kvj+llEdXdE4vFZ3aybTT3zMofuM2ZWeu75cRbXRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdgUNBI9d3VNyYhCh7KATkkcWBtenbgJE5wdzarlhwBe0Yr3Kw5BLb/E8Uc84i2D9
         zSbz1YN0+/zUtIHkxXyjLFpuWe5Bqb9jbapH/8wHbtIS0hvCXPo5/KfZ4AuHyYXAm2
         ixA8vH+zBnJsula4w+wLMW4NEwBk+EbcLd7XFyVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 266/296] cxgb4: avoid accessing registers when clearing filters
Date:   Mon, 31 May 2021 15:15:21 +0200
Message-Id: <20210531130712.685566907@linuxfoundation.org>
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

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit 88c380df84fbd03f9b137c2b9d0a44b9f2f553b0 ]

Hardware register having the server TID base can contain
invalid values when adapter is in bad state (for example,
due to AER fatal error). Reading these invalid values in the
register can lead to out-of-bound memory access. So, fix
by using the saved server TID base when clearing filters.

Fixes: b1a79360ee86 ("cxgb4: Delete all hash and TCAM filters before resource cleanup")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index bde8494215c4..e664e05b9f02 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1042,7 +1042,7 @@ void clear_all_filters(struct adapter *adapter)
 				cxgb4_del_filter(dev, f->tid, &f->fs);
 		}
 
-		sb = t4_read_reg(adapter, LE_DB_SRVR_START_INDEX_A);
+		sb = adapter->tids.stid_base;
 		for (i = 0; i < sb; i++) {
 			f = (struct filter_entry *)adapter->tids.tid_tab[i];
 
-- 
2.30.2



