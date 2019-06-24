Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1F75067A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfFXJ7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbfFXJ67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:58:59 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1118214C6;
        Mon, 24 Jun 2019 09:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370339;
        bh=aOrGG1cBOahIihJ05bmyAadfSEbi8NCeOcF5KGQ0zE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeH04u/v0Rz1kfjjIVVx+cepQiMCtPVUgv4TpjUyWc+ypXVL14f+LMexOyuxFfl8E
         jqnZxZOehH+Xt+BX2SurdRWyUY9K55zRSuE+be9/0zVIAOanjleApsfLLZWkNfL8ly
         /hnXrJksMWqZi/YTMsNhaZU2LhsYGOfy3NQCZ4mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 04/51] net: phy: broadcom: Use strlcpy() for ethtool::get_strings
Date:   Mon, 24 Jun 2019 17:56:22 +0800
Message-Id: <20190624092306.418859848@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 8a17eefa235f73b60c0ca7d397d2e4f66f85f413 upstream.

Our statistics strings are allocated at initialization without being
bound to a specific size, yet, we would copy ETH_GSTRING_LEN bytes using
memcpy() which would create out of bounds accesses, this was flagged by
KASAN. Replace this with strlcpy() to make sure we are bound the source
buffer size and we also always NUL-terminate strings.

Fixes: 820ee17b8d3b ("net: phy: broadcom: Add support code for reading PHY counters")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/bcm-phy-lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -341,8 +341,8 @@ void bcm_phy_get_strings(struct phy_devi
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(bcm_phy_hw_stats); i++)
-		memcpy(data + i * ETH_GSTRING_LEN,
-		       bcm_phy_hw_stats[i].string, ETH_GSTRING_LEN);
+		strlcpy(data + i * ETH_GSTRING_LEN,
+			bcm_phy_hw_stats[i].string, ETH_GSTRING_LEN);
 }
 EXPORT_SYMBOL_GPL(bcm_phy_get_strings);
 


