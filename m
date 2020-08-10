Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF81E24091B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgHJP3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728929AbgHJP27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:28:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B081722BF3;
        Mon, 10 Aug 2020 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073339;
        bh=B7ub19GZPui36HK+WZ3Se0D4ppcQnLcQoBNYj1qYxO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/Zse5MKWj+VgfpDutpxA465iJTU9ssCOUejMPGt5XqR3zFUvHAicsQj6jAtezeOb
         VbjRo/ei/2OUMikKH4i2aYcV+STQZqNm/XVXrZO0iAMHRj6GuFu5xBZn4ieoH62o5s
         hXUCidXHcMtxErbuQOeiBf192MUybCehkcmXlfxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 58/67] dpaa2-eth: Fix passing zero to PTR_ERR warning
Date:   Mon, 10 Aug 2020 17:21:45 +0200
Message-Id: <20200810151812.374552391@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 02afa9c66bb954c6959877c70d9e128dcf0adce7 ]

Fix smatch warning:

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2419
 alloc_channel() warn: passing zero to 'ERR_PTR'

setup_dpcon() should return ERR_PTR(err) instead of zero in error
handling case.

Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2090,7 +2090,7 @@ close:
 free:
 	fsl_mc_object_free(dpcon);
 
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static void free_dpcon(struct dpaa2_eth_priv *priv,
@@ -2114,8 +2114,8 @@ alloc_channel(struct dpaa2_eth_priv *pri
 		return NULL;
 
 	channel->dpcon = setup_dpcon(priv);
-	if (IS_ERR_OR_NULL(channel->dpcon)) {
-		err = PTR_ERR_OR_ZERO(channel->dpcon);
+	if (IS_ERR(channel->dpcon)) {
+		err = PTR_ERR(channel->dpcon);
 		goto err_setup;
 	}
 


