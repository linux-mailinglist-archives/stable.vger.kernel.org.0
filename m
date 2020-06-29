Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704C620E52B
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgF2Vdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgF2Sk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A34924052;
        Mon, 29 Jun 2020 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443923;
        bh=p2Vmo2jSjK79op65VL5twbFOdnnj3SKE1L+bE5826Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIYM9CMg07SOy6UtPoKodt6rrk16yZKmbiEfbhVOXzzf1qAB7ozHNj685Gs0vTm8f
         PQuWLuZV1ovfMVa72mzil7SgSnH0Czfjbn9o2utVGdAMTnfrGoUb07x6AM48LEnseN
         XKeQ3YxZ4focKZkZKrgf4+p274UgBk15+H+hgW+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Christensen <drc@linux.vnet.ibm.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 024/265] tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
Date:   Mon, 29 Jun 2020 11:14:17 -0400
Message-Id: <20200629151818.2493727-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Christensen <drc@linux.vnet.ibm.com>

[ Upstream commit 3a2656a211caf35e56afc9425e6e518fa52f7fbc ]

The driver function tg3_io_error_detected() calls napi_disable twice,
without an intervening napi_enable, when the number of EEH errors exceeds
eeh_max_freezes, resulting in an indefinite sleep while holding rtnl_lock.

Add check for pcierr_recovery which skips code already executed for the
"Frozen" state.

Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ff98a82b7bc47..d71ce7634ac19 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18170,8 +18170,8 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	rtnl_lock();
 
-	/* We probably don't have netdev yet */
-	if (!netdev || !netif_running(netdev))
+	/* Could be second call or maybe we don't have netdev yet */
+	if (!netdev || tp->pcierr_recovery || !netif_running(netdev))
 		goto done;
 
 	/* We needn't recover from permanent error */
-- 
2.25.1

