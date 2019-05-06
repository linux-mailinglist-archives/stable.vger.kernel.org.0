Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C272914D10
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfEFOrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbfEFOrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91CF921019;
        Mon,  6 May 2019 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154052;
        bh=E3pP6r+Tt7mCCHRSN5hTQTQRqAJ1nkxxBBX51vIGfwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiUUysFIgrI4scrfxs8IuPGjv/KPrvqh2vx0QPjBHmt0mOD3BTXXXOZTbKpnu22Pg
         H8UoH9dmxwlSxn8sW9jGYigx98LtMLPdFD+ddkt17qQ34686B3BLIk9QqzCB4QFui/
         sq1fVgr0YEvFChskALNuASNUaXCsriiKi6oER+nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 02/62] ipv4: ip_do_fragment: Preserve skb_iif during fragmentation
Date:   Mon,  6 May 2019 16:32:33 +0200
Message-Id: <20190506143051.313171027@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shmulik Ladkani <shmulik@metanetworks.com>

[ Upstream commit d2f0c961148f65bc73eda72b9fa3a4e80973cb49 ]

Previously, during fragmentation after forwarding, skb->skb_iif isn't
preserved, i.e. 'ip_copy_metadata' does not copy skb_iif from given
'from' skb.

As a result, ip_do_fragment's creates fragments with zero skb_iif,
leading to inconsistent behavior.

Assume for example an eBPF program attached at tc egress (post
forwarding) that examines __sk_buff->ingress_ifindex:
 - the correct iif is observed if forwarding path does not involve
   fragmentation/refragmentation
 - a bogus iif is observed if forwarding path involves
   fragmentation/refragmentatiom

Fix, by preserving skb_iif during 'ip_copy_metadata'.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -492,6 +492,7 @@ static void ip_copy_metadata(struct sk_b
 	to->pkt_type = from->pkt_type;
 	to->priority = from->priority;
 	to->protocol = from->protocol;
+	to->skb_iif = from->skb_iif;
 	skb_dst_drop(to);
 	skb_dst_copy(to, from);
 	to->dev = from->dev;


