Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9626F4D700
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfFTSOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbfFTSOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E27F21530;
        Thu, 20 Jun 2019 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054491;
        bh=O1AOVWIfY8FUP0UKPr0TTotD4YyJ3xpe9kg3M8Azp08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KqBXslC9KyRVaAphIEmZ9vLjPCrqAGDzypsjcWnobHIGfdFdmcDEoSCfCqvf75kF
         7+x1/m1gVrP+JAcqwxNGdny5i3ePsFVcpOMG9QsbiPtnUzMIDiCHOOwRpLBIM5njUf
         LGLvALcWgsXmGScFQQJ5eVND9VKEe2sYXpm2vzQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 17/98] vxlan: Dont assume linear buffers in error handler
Date:   Thu, 20 Jun 2019 19:56:44 +0200
Message-Id: <20190620174350.058456278@linuxfoundation.org>
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

[ Upstream commit 8399a6930d12f5965230f4ff058228a4cc80c0b9 ]

In commit c3a43b9fec8a ("vxlan: ICMP error lookup handler") I wrongly
assumed buffers from icmp_socket_deliver() would be linear. This is not
the case: icmp_socket_deliver() only guarantees we have 8 bytes of linear
data.

Eric fixed this same issue for fou and fou6 in commits 26fc181e6cac
("fou, fou6: do not assume linear skbs") and 5355ed6388e2 ("fou, fou6:
avoid uninit-value in gue_err() and gue6_err()").

Use pskb_may_pull() instead of checking skb->len, and take into account
the fact we later access the VXLAN header with udp_hdr(), so we also
need to sum skb_transport_header() here.

Reported-by: Guillaume Nault <gnault@redhat.com>
Fixes: c3a43b9fec8a ("vxlan: ICMP error lookup handler")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1765,7 +1765,7 @@ static int vxlan_err_lookup(struct sock
 	struct vxlanhdr *hdr;
 	__be32 vni;
 
-	if (skb->len < VXLAN_HLEN)
+	if (!pskb_may_pull(skb, skb_transport_offset(skb) + VXLAN_HLEN))
 		return -EINVAL;
 
 	hdr = vxlan_hdr(skb);


