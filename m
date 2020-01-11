Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48C5137F03
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgAKKPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:15:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbgAKKPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:15:54 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC1120848;
        Sat, 11 Jan 2020 10:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737753;
        bh=Z8ksYwPemdXrZ6H22mZdTp/D5Owf5h5ychDnd3Hi6Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uinKs5ZZOVLfYY95szEXnvfzxK1mH5n4xE966k6NedV8bzZt0N2l7aGPl2dn+nNou
         PpR6P6vp/dppB5YCsaTEIpXeducVoX75wHbPXmN8GzhiFEWsVNYq4N8X8/L2SPncD9
         tIefD/NKGKsTA1vpzAwZgrhr7FrhnnEPHaqha9ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herat Ramani <herat@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/84] cxgb4: Fix kernel panic while accessing sge_info
Date:   Sat, 11 Jan 2020 10:50:15 +0100
Message-Id: <20200111094900.746972054@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>

[ Upstream commit 479a0d1376f6d97c60871442911f1394d4446a25 ]

The sge_info debugfs collects offload queue info even when offload
capability is disabled and leads to panic.

[  144.139871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  144.139874] CR2: 0000000000000000 CR3: 000000082d456005 CR4: 00000000001606e0
[  144.139876] Call Trace:
[  144.139887]  sge_queue_start+0x12/0x30 [cxgb4]
[  144.139897]  seq_read+0x1d4/0x3d0
[  144.139906]  full_proxy_read+0x50/0x70
[  144.139913]  vfs_read+0x89/0x140
[  144.139916]  ksys_read+0x55/0xd0
[  144.139924]  do_syscall_64+0x5b/0x1d0
[  144.139933]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  144.139936] RIP: 0033:0x7f4b01493990

Fix this crash by skipping the offload queue access in sge_qinfo when
offload capability is disabled

Signed-off-by: Herat Ramani <herat@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index b429b726b987..d320e9afab88 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3035,6 +3035,9 @@ static int sge_queue_entries(const struct adapter *adap)
 	int tot_uld_entries = 0;
 	int i;
 
+	if (!is_uld(adap))
+		goto lld_only;
+
 	mutex_lock(&uld_mutex);
 	for (i = 0; i < CXGB4_TX_MAX; i++)
 		tot_uld_entries += sge_qinfo_uld_txq_entries(adap, i);
@@ -3045,6 +3048,7 @@ static int sge_queue_entries(const struct adapter *adap)
 	}
 	mutex_unlock(&uld_mutex);
 
+lld_only:
 	return DIV_ROUND_UP(adap->sge.ethqsets, 4) +
 	       tot_uld_entries +
 	       DIV_ROUND_UP(MAX_CTRL_QUEUES, 4) + 1;
-- 
2.20.1



