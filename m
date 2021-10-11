Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC57428F72
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238091AbhJKN7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237131AbhJKN5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:57:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 876DB60F6E;
        Mon, 11 Oct 2021 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960436;
        bh=wlfZdwYdVAsEA6R9GQFkDQmZUOzjedhFrxJLH4Ar3g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdkoRxx40dVz3UgQauk1TSSfFYUtUAyJdy3yNy48JiE1BubSLr6pxJ5C9TXvG3XTg
         pZtZmW8mshbGGS9DzydtL6df0irjROMPJn3LNjs0z+/ysP/Df5CeDTlAj38JmGLxXh
         5CUu0Vbq7N9VK9b+w71ze9RquD97prICU5UvQrWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/83] gve: Correct available tx qpl check
Date:   Mon, 11 Oct 2021 15:46:19 +0200
Message-Id: <20211011134510.429075159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
index f5c80229ea96..cfb174624d4e 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -472,7 +472,7 @@ struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv)
 				    gve_num_tx_qpls(priv));
 
 	/* we are out of rx qpls */
-	if (id == priv->qpl_cfg.qpl_map_size)
+	if (id == gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv))
 		return NULL;
 
 	set_bit(id, priv->qpl_cfg.qpl_id_map);
-- 
2.33.0



