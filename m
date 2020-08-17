Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD4D247032
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390246AbgHQSF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388498AbgHQQJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:09:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECBA122D02;
        Mon, 17 Aug 2020 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680553;
        bh=lMGiXrzYGdWXjhjBqQbKNddRV33RGM0bKcrYbvO8UZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNFa5F6Kf1cYMIgYRg2wCqfQltkEbLdHXkK/qZwHWOzLXVaWJdxTgaGvpm2fto53f
         CP0DwmezAkol22JHbGC8mp8wIjIQTo92JAqZcPVr0qZrLq5lDfRCTndN6DgrgBG0xB
         fvyDGaBtsBqQcdfYOZuuD8lD+blQQhbRlZbm16fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronak Doshi <doshir@vmware.com>,
        Guolin Yang <gyang@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 225/270] vmxnet3: use correct tcp hdr length when packet is encapsulated
Date:   Mon, 17 Aug 2020 17:17:06 +0200
Message-Id: <20200817143806.984713313@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>

[ Upstream commit 8a7f280f29a80f6e0798f5d6e07c5dd8726620fe ]

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, while
calculating tcp hdr length, it does not take into account if the
packet is encapsulated or not.

This patch fixes this issue by using correct reference for inner
tcp header.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -861,7 +861,8 @@ vmxnet3_parse_hdr(struct sk_buff *skb, s
 
 			switch (protocol) {
 			case IPPROTO_TCP:
-				ctx->l4_hdr_size = tcp_hdrlen(skb);
+				ctx->l4_hdr_size = skb->encapsulation ? inner_tcp_hdrlen(skb) :
+						   tcp_hdrlen(skb);
 				break;
 			case IPPROTO_UDP:
 				ctx->l4_hdr_size = sizeof(struct udphdr);


