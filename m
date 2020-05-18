Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA871D8657
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgERRoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbgERRoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D60E20715;
        Mon, 18 May 2020 17:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823855;
        bh=QO9TZvUO7IE6Ksg12DGblAXw8sMQrH5Vu4SkEHvgSEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZWW0NQjPRsGmGZEIAIgP8l1KU5L8OUAEODQlXPyxK1v7n4r5eGEyJlt+GOGv+KbZ
         Tt0jkEFL9dgMRy2gub+mfkR+P8h2O9jEgt4qyFL7v2lPSuoNHZW+48E17OMNQ78yvw
         +GgtZ5XS4dKE7SUT2IxkbAZL5YOZWjfg833nCmlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 62/90] net: phy: micrel: Use strlcpy() for ethtool::get_strings
Date:   Mon, 18 May 2020 19:36:40 +0200
Message-Id: <20200518173503.737543425@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
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
@@ -677,8 +677,8 @@ static void kszphy_get_strings(struct ph
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(kszphy_hw_stats); i++) {
-		memcpy(data + i * ETH_GSTRING_LEN,
-		       kszphy_hw_stats[i].string, ETH_GSTRING_LEN);
+		strlcpy(data + i * ETH_GSTRING_LEN,
+			kszphy_hw_stats[i].string, ETH_GSTRING_LEN);
 	}
 }
 


