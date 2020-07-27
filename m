Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B06122F139
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731776AbgG0OVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbgG0OVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 170EA2070B;
        Mon, 27 Jul 2020 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859703;
        bh=OdLkRB2xOGe8mEdYlFzHbiS2fJS4dERxvM6LXLy6FXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCPJoEkqNZ+32x9Kkxi7djg9E0d6gIsxRDCAwl9qBO3Pn+aLBkVmjno+cXr769LU3
         9p/ILJkahKZSgAfnl/QBVAhTpONGKwLqnGJ7os/dFrlWyQApGK/xDa48la5fnHvftB
         V1NYUMtXrxBOnxIeKu5kML+BvpHd3y0+cDfPo5uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 072/179] ionic: update filter id after replay
Date:   Mon, 27 Jul 2020 16:04:07 +0200
Message-Id: <20200727134936.194813700@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit cc4428c4de8c31f12e4690d0409e0432fe05702f ]

When we replay the rx filters after a fw-upgrade we get new
filter_id values from the FW, which we need to save and update
in our local filter list.  This allows us to delete the filters
with the correct filter_id when we're done.

Fixes: 7e4d47596b68 ("ionic: replay filters after fw upgrade")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index fb9d828812bd2..cd0076fc3044e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -21,13 +21,16 @@ void ionic_rx_filter_free(struct ionic_lif *lif, struct ionic_rx_filter *f)
 void ionic_rx_filter_replay(struct ionic_lif *lif)
 {
 	struct ionic_rx_filter_add_cmd *ac;
+	struct hlist_head new_id_list;
 	struct ionic_admin_ctx ctx;
 	struct ionic_rx_filter *f;
 	struct hlist_head *head;
 	struct hlist_node *tmp;
+	unsigned int key;
 	unsigned int i;
 	int err;
 
+	INIT_HLIST_HEAD(&new_id_list);
 	ac = &ctx.cmd.rx_filter_add;
 
 	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
@@ -58,9 +61,30 @@ void ionic_rx_filter_replay(struct ionic_lif *lif)
 						    ac->mac.addr);
 					break;
 				}
+				spin_lock_bh(&lif->rx_filters.lock);
+				ionic_rx_filter_free(lif, f);
+				spin_unlock_bh(&lif->rx_filters.lock);
+
+				continue;
 			}
+
+			/* remove from old id list, save new id in tmp list */
+			spin_lock_bh(&lif->rx_filters.lock);
+			hlist_del(&f->by_id);
+			spin_unlock_bh(&lif->rx_filters.lock);
+			f->filter_id = le32_to_cpu(ctx.comp.rx_filter_add.filter_id);
+			hlist_add_head(&f->by_id, &new_id_list);
 		}
 	}
+
+	/* rebuild the by_id hash lists with the new filter ids */
+	spin_lock_bh(&lif->rx_filters.lock);
+	hlist_for_each_entry_safe(f, tmp, &new_id_list, by_id) {
+		key = f->filter_id & IONIC_RX_FILTER_HLISTS_MASK;
+		head = &lif->rx_filters.by_id[key];
+		hlist_add_head(&f->by_id, head);
+	}
+	spin_unlock_bh(&lif->rx_filters.lock);
 }
 
 int ionic_rx_filters_init(struct ionic_lif *lif)
-- 
2.25.1



