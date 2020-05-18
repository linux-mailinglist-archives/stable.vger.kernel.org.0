Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400CD1D8606
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgERSWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730643AbgERRuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0258C20715;
        Mon, 18 May 2020 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824212;
        bh=BGrUQXV/yqAhlRe7H5uRdVG7HYZS4HWVg5llJ9rmNZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaPoVRr9iVvTCxDaw48YFsuy4Br8pDvvf2ccmy+z/vEjAh2NfweyvdmPSrAXFd50l
         8dtUhl3nWvxRjEvYJJWDkxHJFrvTqxyG18W+KdiBnkUAVkfy3lRHDBQime/l5wbOWL
         4erSdQEDh/BKVOs+v0lYt30x+iqcFvkW36H/uwNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 080/114] net: phy: micrel: Use strlcpy() for ethtool::get_strings
Date:   Mon, 18 May 2020 19:36:52 +0200
Message-Id: <20200518173516.999983111@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 55f53567afe5f0cd2fd9e006b174c08c31c466f8 upstream.

Our statistics strings are allocated at initialization without being
bound to a specific size, yet, we would copy ETH_GSTRING_LEN bytes using
memcpy() which would create out of bounds accesses, this was flagged by
KASAN. Replace this with strlcpy() to make sure we are bound the source
buffer size and we also always NUL-terminate strings.

Fixes: 2b2427d06426 ("phy: micrel: Add ethtool statistics counters")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/micrel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -674,8 +674,8 @@ static void kszphy_get_strings(struct ph
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(kszphy_hw_stats); i++) {
-		memcpy(data + i * ETH_GSTRING_LEN,
-		       kszphy_hw_stats[i].string, ETH_GSTRING_LEN);
+		strlcpy(data + i * ETH_GSTRING_LEN,
+			kszphy_hw_stats[i].string, ETH_GSTRING_LEN);
 	}
 }
 


