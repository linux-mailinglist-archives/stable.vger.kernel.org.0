Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4BB1F439
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfEOK6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbfEOK6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 136A620843;
        Wed, 15 May 2019 10:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917926;
        bh=Ih05TbITOBRLzrs6ddr9NMm5nj9No0Ggxr+8IMzbrhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYN+Yx+ODoxucpEMjKVNa/KRz2l0CxwEgdB9C3syWegjRbpLMsfXE/eRF7wzgknkF
         3AeRNRWhP1ZxJV6M08SkpmsnwYQCKY1o/Ox1YCJSRllDFmgeQwWcopSaT67lUhnUqA
         4hmp3WNNZA0ExFCH0Z0Jlv2nh70PZ+0B+hIAHG/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 28/86] ipv4: ip_do_fragment: Preserve skb_iif during fragmentation
Date:   Wed, 15 May 2019 12:55:05 +0200
Message-Id: <20190515090648.418986290@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
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
@@ -454,6 +454,7 @@ static void ip_copy_metadata(struct sk_b
 	to->pkt_type = from->pkt_type;
 	to->priority = from->priority;
 	to->protocol = from->protocol;
+	to->skb_iif = from->skb_iif;
 	skb_dst_drop(to);
 	skb_dst_copy(to, from);
 	to->dev = from->dev;


