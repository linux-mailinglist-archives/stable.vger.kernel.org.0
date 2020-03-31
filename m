Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8501991DC
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgCaJIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731127AbgCaJIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:08:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8538A2072E;
        Tue, 31 Mar 2020 09:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645705;
        bh=LUr+Qy3SYx/y4w3WfYIPeBIObF+JeJjDiX67mmvdWiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5n4ExNBQqTVI0W8EnUglYyLDkR9ZTBGaG8VhR5FL86TNVOZOEbH4iQ9AsKfQVPOa
         nLqYfxQkVIVAoS6rsCeXvK3r0YSpPPPIjSLv7Qs5i5k7gPkYtHe/gWpCY0VBFRj/WC
         NdhYqhQNINXDsyDw4xYuKTiFjAkiXCbVrskJLtfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 138/170] netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
Date:   Tue, 31 Mar 2020 10:59:12 +0200
Message-Id: <20200331085438.148415210@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit bcfabee1afd99484b6ba067361b8678e28bbc065 upstream.

Set skb->tc_redirected to 1, otherwise the ifb driver drops the packet.
Set skb->tc_from_ingress to 1 to reinject the packet back to the ingress
path after leaving the ifb egress path.

This patch inconditionally sets on these two skb fields that are
meaningful to the ifb driver. The existing forward action is guaranteed
to run from ingress path.

Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_fwd_netdev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -28,6 +28,10 @@ static void nft_fwd_netdev_eval(const st
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 	int oif = regs->data[priv->sreg_dev];
 
+	/* These are used by ifb only. */
+	pkt->skb->tc_redirected = 1;
+	pkt->skb->tc_from_ingress = 1;
+
 	nf_fwd_netdev_egress(pkt, oif);
 	regs->verdict.code = NF_STOLEN;
 }


