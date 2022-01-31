Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BA24A4212
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359050AbiAaLKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40236 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359535AbiAaLFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:05:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EA7660FF5;
        Mon, 31 Jan 2022 11:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9BBC340EE;
        Mon, 31 Jan 2022 11:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627147;
        bh=AIh8bcIWrRf1bu2DJjMdLk+QgJB8K2W75FM7fvF8Zj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtMV0NNfsi02efq8tCV93eF3UeiiFsDVw6ieEkd+ziwXHZykKw0vRhyaUsE53c7Uq
         a9qRsd45FN7gYB/j0+WIdL3GPYfroGKJTGgGbJuA4qLtc7bwhHRF/gdr2UH3I45fjH
         QHl15BROkVq5sZFfpbopa9lx4cn5g8UXrfWrvGeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/100] net: cpsw: Properly initialise struct page_pool_params
Date:   Mon, 31 Jan 2022 11:56:50 +0100
Message-Id: <20220131105223.452077670@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
index 424e644724e46..e74f2e95a46eb 100644
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



