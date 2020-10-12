Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97C328B8D4
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390440AbgJLNzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389676AbgJLNpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFA9C22267;
        Mon, 12 Oct 2020 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510269;
        bh=kLgP74XDZOeHGEXeKldGAeWP/IgRb+BJcNdw6TDIAtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kd70q63xhMKgTkBVJSZ6boMPbh5wG1MQKstK9COwwC89eAhoULpSt2XGzJPX89y9P
         f8zS85YRhwdgLSKL71QpYTbQH3opy9W5skH1yet+HTvfMlfJeo2d0lQkdkuzMe30pj
         eZoYC5K4O3owVncGsW4wH2eWH4hqs3dzRWcVOPE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 027/124] macsec: avoid use-after-free in macsec_handle_frame()
Date:   Mon, 12 Oct 2020 15:30:31 +0200
Message-Id: <20201012133148.161197400@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit c7cc9200e9b4a2ac172e990ef1975cd42975dad6 upstream.

De-referencing skb after call to gro_cells_receive() is not allowed.
We need to fetch skb->len earlier.

Fixes: 5491e7c6b1a9 ("macsec: enable GRO and RPS on macsec devices")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macsec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1077,6 +1077,7 @@ static rx_handler_result_t macsec_handle
 	struct macsec_rx_sa *rx_sa;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
+	unsigned int len;
 	sci_t sci;
 	u32 hdr_pn;
 	bool cbit;
@@ -1232,9 +1233,10 @@ deliver:
 	macsec_rxsc_put(rx_sc);
 
 	skb_orphan(skb);
+	len = skb->len;
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
-		count_rx(dev, skb->len);
+		count_rx(dev, len);
 	else
 		macsec->secy.netdev->stats.rx_dropped++;
 


