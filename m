Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683B228B6E5
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgJLNih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731016AbgJLNhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865C922227;
        Mon, 12 Oct 2020 13:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509828;
        bh=hocMgNtBd4DxsvkWNVvvyAOw39ZzxOwXGRKQIWOYQeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQnvh+9TiqVuiA1Fti7nyFBtGIF5Vo6UzXSDuXVhYpiGwm+i49/9Onb6B1oEZLnzs
         Uk6yCLhCyB6FnyF5BApN3UxhEP3sZxagyJhma4UPWlo9ZA59S1WkfXn1J2801/gxwT
         +KrwOyzHBJRavKXBhuwinE1a0ik9+mFYbCL6Cscs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 45/70] macsec: avoid use-after-free in macsec_handle_frame()
Date:   Mon, 12 Oct 2020 15:27:01 +0200
Message-Id: <20201012132632.349654207@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
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
@@ -1081,6 +1081,7 @@ static rx_handler_result_t macsec_handle
 	struct macsec_rx_sa *rx_sa;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
+	unsigned int len;
 	sci_t sci;
 	u32 pn;
 	bool cbit;
@@ -1236,9 +1237,10 @@ deliver:
 	macsec_rxsc_put(rx_sc);
 
 	skb_orphan(skb);
+	len = skb->len;
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
-		count_rx(dev, skb->len);
+		count_rx(dev, len);
 	else
 		macsec->secy.netdev->stats.rx_dropped++;
 


