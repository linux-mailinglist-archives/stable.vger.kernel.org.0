Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7281199167
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgCaJRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731897AbgCaJRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9217F20675;
        Tue, 31 Mar 2020 09:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646239;
        bh=LUr+Qy3SYx/y4w3WfYIPeBIObF+JeJjDiX67mmvdWiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AU+VqdjCxg1lHjSr9bCdhV7ZwkzNg5sApLy0vfJziKvHP4DRlJP1HjgG2oPpGaSxr
         0q4CxseznnZhcWj/yUyNQeNDm0FUsO9Dv0rI209jtdUFsugOY8Bgs0MtW2r4eCIoQ8
         Jf9Zm7AsF8HcKtYMSTDidJc7B41tTC+JPLX6xOb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 126/155] netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
Date:   Tue, 31 Mar 2020 10:59:26 +0200
Message-Id: <20200331085432.460087902@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
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


