Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE833CA383
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732566AbfJCQPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388862AbfJCQPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:15:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925B420700;
        Thu,  3 Oct 2019 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119351;
        bh=bbTKLwu6LByg5hrqRRMmlhrRluWfWwOtjqI2kMTKy+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffXFbfE+1jhHLr6qMzDoDpspQpF6e6Ze3foZzCvTRtVDqGOM8/PgXFbVAQLJYvjBy
         Lyu8+g+IqlI3pXQemIq0KL3ighg3zErZK92y1GdES/scir6Y/EzcEN5XSpTRcLxg5P
         be7rRSPJLPil5zlwN26oopGmJxViXWO1Ag0cmLEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 008/211] nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs
Date:   Thu,  3 Oct 2019 17:51:14 +0200
Message-Id: <20191003154449.111320254@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
@@ -373,6 +373,7 @@ nfp_flower_spawn_phy_reprs(struct nfp_ap
 		repr_priv = kzalloc(sizeof(*repr_priv), GFP_KERNEL);
 		if (!repr_priv) {
 			err = -ENOMEM;
+			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
 
@@ -382,6 +383,7 @@ nfp_flower_spawn_phy_reprs(struct nfp_ap
 		port = nfp_port_alloc(app, NFP_PORT_PHYS_PORT, repr);
 		if (IS_ERR(port)) {
 			err = PTR_ERR(port);
+			kfree(repr_priv);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;
 		}
@@ -399,6 +401,7 @@ nfp_flower_spawn_phy_reprs(struct nfp_ap
 		err = nfp_repr_init(app, repr,
 				    cmsg_port_id, port, priv->nn->dp.netdev);
 		if (err) {
+			kfree(repr_priv);
 			nfp_port_free(port);
 			nfp_repr_free(repr);
 			goto err_reprs_clean;


