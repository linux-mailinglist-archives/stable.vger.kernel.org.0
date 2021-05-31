Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE453962D1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhEaPBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhEaO7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD7C1610A1;
        Mon, 31 May 2021 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469673;
        bh=KTKfHna5npzVuNtlLa5MElhrWR88XroK6QG//w9uI+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSVoKJIb+zHAIz6Msp4nO0ltzqELbF3Gt7+/7sNALx6UA9YEKyMto2zpp+kHf0f8J
         s13u4DlhR4axAwsAfA50yJQXJPUo6t+VhYqKsMa65aFI6YEWjtn+O92eHGUgifCXDr
         1v/CcSLN8SSFVW6BhMahz3sdl84adkQjs+l5wwOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Awogbemila <awogbemila@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 252/296] gve: Update mgmt_msix_idx if num_ntfy changes
Date:   Mon, 31 May 2021 15:15:07 +0200
Message-Id: <20210531130712.235657719@linuxfoundation.org>
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

From: David Awogbemila <awogbemila@google.com>

[ Upstream commit e96b491a0ffa35a8a9607c193fa4d894ca9fb32f ]

If we do not get the expected number of vectors from
pci_enable_msix_range, we update priv->num_ntfy_blks but not
priv->mgmt_msix_idx. This patch fixes this so that priv->mgmt_msix_idx
is updated accordingly.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 7302498c6df3..64192942ca53 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -220,6 +220,7 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		int vecs_left = new_num_ntfy_blks % 2;
 
 		priv->num_ntfy_blks = new_num_ntfy_blks;
+		priv->mgmt_msix_idx = priv->num_ntfy_blks;
 		priv->tx_cfg.max_queues = min_t(int, priv->tx_cfg.max_queues,
 						vecs_per_type);
 		priv->rx_cfg.max_queues = min_t(int, priv->rx_cfg.max_queues,
-- 
2.30.2



