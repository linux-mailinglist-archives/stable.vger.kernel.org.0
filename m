Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887354D702
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfFTSO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729288AbfFTSOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B311205F4;
        Thu, 20 Jun 2019 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054493;
        bh=YR5qsibLBz6MkHT9JmmO8QWMeEftMZt6WOL/PZ8HGjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLaRj4lJmO/lijU58iQq9HOPVV7TOodXz04dcHJdq6Bocp4zA2lQNwPj0q5kSSKA8
         7+0fxFME9oq1rxZ3hGqIjbtk54d/M+cXWWMzLIMuQmUWRgYU3iJ75XsS2tuyCWVv0j
         UeXvFZHCuK/3fhxnU3IrE+o7deIYpy8m22sHZgjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 18/98] geneve: Dont assume linear buffers in error handler
Date:   Thu, 20 Jun 2019 19:56:45 +0200
Message-Id: <20190620174350.089480832@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit eccc73a6b2cb6c04bfbc40a0769f3c428dfba232 ]

In commit a07966447f39 ("geneve: ICMP error lookup handler") I wrongly
assumed buffers from icmp_socket_deliver() would be linear. This is not
the case: icmp_socket_deliver() only guarantees we have 8 bytes of linear
data.

Eric fixed this same issue for fou and fou6 in commits 26fc181e6cac
("fou, fou6: do not assume linear skbs") and 5355ed6388e2 ("fou, fou6:
avoid uninit-value in gue_err() and gue6_err()").

Use pskb_may_pull() instead of checking skb->len, and take into account
the fact we later access the GENEVE header with udp_hdr(), so we also
need to sum skb_transport_header() here.

Reported-by: Guillaume Nault <gnault@redhat.com>
Fixes: a07966447f39 ("geneve: ICMP error lookup handler")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -396,7 +396,7 @@ static int geneve_udp_encap_err_lookup(s
 	u8 zero_vni[3] = { 0 };
 	u8 *vni = zero_vni;
 
-	if (skb->len < GENEVE_BASE_HLEN)
+	if (!pskb_may_pull(skb, skb_transport_offset(skb) + GENEVE_BASE_HLEN))
 		return -EINVAL;
 
 	geneveh = geneve_hdr(skb);


