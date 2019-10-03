Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD1BCA92B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392152AbfJCQib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389681AbfJCQia (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99AD20830;
        Thu,  3 Oct 2019 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120710;
        bh=mg/lXnaKl1n2LEuLDz3EK4eUsnnzZrYumsSwGKfrScA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5/w8GFXWJJwFyvL8LM6pfh3gDE1pbwTsNhgjK9om5jYoT2nksWFu5dXTDNK9oBLg
         ZOt/nG5gljfYQ8/vmnv07VILdQuqciCNmTIXssWNbZD4I1G/ARC4sUyvy93lSMBAzK
         T0I/WLNKe5/bsr9ejNEMVD3gxDXv0oN4IMzBZiPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 010/344] nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs
Date:   Thu,  3 Oct 2019 17:49:35 +0200
Message-Id: <20191003154541.106436730@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 8ce39eb5a67aee25d9f05b40b673c95b23502e3e ]

In nfp_flower_spawn_vnic_reprs in the loop if initialization or the
allocations fail memory is leaked. Appropriate releases are added.

Fixes: b94524529741 ("nfp: flower: add per repr private data for LAG offload")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -400,6 +400,7 @@ nfp_flower_spawn_vnic_reprs(struct nfp_a
 		repr_priv = kzalloc(sizeof(*repr_priv), GFP_KERNEL);
 		if (!repr_priv) {
 			err = -ENOMEM;
+			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
 
@@ -413,6 +414,7 @@ nfp_flower_spawn_vnic_reprs(struct nfp_a
 		port = nfp_port_alloc(app, port_type, repr);
 		if (IS_ERR(port)) {
 			err = PTR_ERR(port);
+			kfree(repr_priv);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
@@ -433,6 +435,7 @@ nfp_flower_spawn_vnic_reprs(struct nfp_a
 		err = nfp_repr_init(app, repr,
 				    port_id, port, priv->nn->dp.netdev);
 		if (err) {
+			kfree(repr_priv);
 			nfp_port_free(port);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;


