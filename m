Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D6B428ED9
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbhJKNwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236433AbhJKNvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8340360EB4;
        Mon, 11 Oct 2021 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960164;
        bh=YHK9LF7MHxvCWm8u3yvM9HZ/76pAoR3qWodjtDuaDJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fnu7iIJYu7JMOW+z+xKWot+1B5W6HDspT50QeN9slb4VxZlywI6a6X5kG+qGWqLzO
         wM4/Y0UqswHcdiMPMcnCwDygwyD9ZfMPYvPMxJQambdT2zvLbFgjT9lLmzC+xGOWX+
         KJZHp/3yv/cWwxyRyuwDqFigu4aTwdfzSAbxhiQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/52] gve: Correct available tx qpl check
Date:   Mon, 11 Oct 2021 15:46:09 +0200
Message-Id: <20211011134505.101363550@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

[ Upstream commit d03477ee10f4bc35d3573cf1823814378ef2dca2 ]

The qpl_map_size is rounded up to a multiple of sizeof(long), but the
number of qpls doesn't have to be.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index ebc37e256922..f19edd4c6c5b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -391,7 +391,7 @@ struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv)
 				    gve_num_tx_qpls(priv));
 
 	/* we are out of rx qpls */
-	if (id == priv->qpl_cfg.qpl_map_size)
+	if (id == gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv))
 		return NULL;
 
 	set_bit(id, priv->qpl_cfg.qpl_id_map);
-- 
2.33.0



