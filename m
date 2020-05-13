Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C81D0E53
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbgEMJ72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387450AbgEMJxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9277923127;
        Wed, 13 May 2020 09:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363602;
        bh=TlT7PaR9dkyX6jd4ZuvSgQwZhY1dVip0Q7ChdmokFDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMzAAb287QCrpPc4QoVdeez7Vc0fL82y/PdUWCW9pdK+e3xv/NyKKX9ynr99O/6f7
         5chpdq8lKEW3jcmYyKdXYCudMIZi045nokIlzS7EdxMD3W2e9662trCa6I/B8v0OSj
         jNbCM58YmOFkQ2xEGn4ihi6nrcLq8co94voR4Dyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 050/118] net: mvpp2: prevent buffer overflow in mvpp22_rss_ctx()
Date:   Wed, 13 May 2020 11:44:29 +0200
Message-Id: <20200513094421.545373030@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 39bd16df7c31bb8cf5dfd0c88e42abd5ae10029d ]

The "rss_context" variable comes from the user via  ethtool_get_rxfh().
It can be any u32 value except zero.  Eventually it gets passed to
mvpp22_rss_ctx() and if it is over MVPP22_N_RSS_TABLES (8) then it
results in an array overflow.

Fixes: 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4325,6 +4325,8 @@ static int mvpp2_ethtool_get_rxfh_contex
 
 	if (!mvpp22_rss_is_supported())
 		return -EOPNOTSUPP;
+	if (rss_context >= MVPP22_N_RSS_TABLES)
+		return -EINVAL;
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_CRC32;


