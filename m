Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF9F1FB81F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbgFPPx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732864AbgFPPxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:53:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 235DE208D5;
        Tue, 16 Jun 2020 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322804;
        bh=8DHEUyrxUYcT2iumm9RzdbJZzd0UEQ03DEP40wWww9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3vA4xANUnKFI2Pu5VzCuuSXh1rhlDA/A3uXuQtmljNvGqIRrAgcFVIJLJFvSW6S9
         uZzCQWreTJuaHwdO5Ypw7m27R919kpg5czFhIOWz8xl+ivC0E/3O6sSbdffCS3jIyz
         MMDg+VFOcPcKsTfwTsuhGakjnBBSvaJA5G7StZW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 111/161] net/mlx5e: Fix repeated XSK usage on one channel
Date:   Tue, 16 Jun 2020 17:35:01 +0200
Message-Id: <20200616153111.643262034@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 36d45fb9d2fdf348d778bfe73f0427db1c6f9bc7 ]

After an XSK is closed, the relevant structures in the channel are not
zeroed. If an XSK is opened the second time on the same channel without
recreating channels, the stray values in the structures will lead to
incorrect operation of queues, which causes CQE errors, and the new
socket doesn't work at all.

This patch fixes the issue by explicitly zeroing XSK-related structs in
the channel on XSK close. Note that those structs are zeroed on channel
creation, and usually a configuration change (XDP program is set)
happens on XSK open, which leads to recreating channels, so typical XSK
usecases don't suffer from this issue. However, if XSKs are opened and
closed on the same channel without removing the XDP program, this bug
reproduces.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -152,6 +152,10 @@ void mlx5e_close_xsk(struct mlx5e_channe
 	mlx5e_close_cq(&c->xskicosq.cq);
 	mlx5e_close_xdpsq(&c->xsksq);
 	mlx5e_close_cq(&c->xsksq.cq);
+
+	memset(&c->xskrq, 0, sizeof(c->xskrq));
+	memset(&c->xsksq, 0, sizeof(c->xsksq));
+	memset(&c->xskicosq, 0, sizeof(c->xskicosq));
 }
 
 void mlx5e_activate_xsk(struct mlx5e_channel *c)


