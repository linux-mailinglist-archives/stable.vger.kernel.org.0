Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566494A45B2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350768AbiAaLqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351297AbiAaLk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:40:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492C2C08E824;
        Mon, 31 Jan 2022 03:25:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC794612D5;
        Mon, 31 Jan 2022 11:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CA9C340E8;
        Mon, 31 Jan 2022 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628357;
        bh=PkNlFSXkB/ip+PcF+kXge0gQV1xVzpWX/F3a461szwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7DBj2zcQ18YALbjnx/yNjzv7j5dFk749JWUBfPBenK3oZdokdpPy3LH1IxAsxSNq
         GBEVTTbDVATDLoI5cML6RuKkjunWwsy+bk5NDJGqAoZ/4ZT3YG/+saAJ9nMdEVmNin
         GyM6sISyGlXxgd7ALWtWtL/hJAEaskuQd2Ror7gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 173/200] net: cpsw: Properly initialise struct page_pool_params
Date:   Mon, 31 Jan 2022 11:57:16 +0100
Message-Id: <20220131105239.373187966@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit c63003e3d99761afb280add3b30de1cf30fa522b ]

The cpsw driver didn't properly initialise the struct page_pool_params
before calling page_pool_create(), which leads to crashes after the struct
has been expanded with new parameters.

The second Fixes tag below is where the buggy code was introduced, but
because the code was moved around this patch will only apply on top of the
commit in the first Fixes tag.

Fixes: c5013ac1dd0e ("net: ethernet: ti: cpsw: move set of common functions in cpsw_priv")
Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")
Reported-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 6bb5ac51d23c3..f8e591d69d2cb 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1144,7 +1144,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
 					       int size)
 {
-	struct page_pool_params pp_params;
+	struct page_pool_params pp_params = {};
 	struct page_pool *pool;
 
 	pp_params.order = 0;
-- 
2.34.1



