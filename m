Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9B02788C7
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgIYM5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729043AbgIYMuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3CFC21D7A;
        Fri, 25 Sep 2020 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038218;
        bh=MqW5lPO7iN+bXu26nDh8UKB/w74ZaqgSPG8YP/YJbtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhWYMgZgXABX6CRr4D8puuYCimo8OCVw2RBzCJgxOpPs1n6ZSdSY1caNvxe4/ACJ9
         BcUqTQNCMR5bQAt1h5pbmcLUBkciFghVc9sFKkKRNvyJzKx+mthmLkT2/1tBBAB29k
         Shb3KLiX2MzfN/gnJZH4Xy/pW5UNDxiqXrcwLzVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadym Kochan <vadym.kochan@plvision.eu>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 46/56] net: ipa: fix u32_replace_bits by u32p_xxx version
Date:   Fri, 25 Sep 2020 14:48:36 +0200
Message-Id: <20200925124734.742303168@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>

[ Upstream commit c047dc1d260f2593035d63747d616c3512f9d6b6 ]

Looks like u32p_replace_bits() should be used instead of
u32_replace_bits() which does not modifies the value but returns the
modified version.

Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_table.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -521,7 +521,7 @@ static void ipa_filter_tuple_zero(struct
 	val = ioread32(endpoint->ipa->reg_virt + offset);
 
 	/* Zero all filter-related fields, preserving the rest */
-	u32_replace_bits(val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
+	u32p_replace_bits(&val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
@@ -572,7 +572,7 @@ static void ipa_route_tuple_zero(struct
 	val = ioread32(ipa->reg_virt + offset);
 
 	/* Zero all route-related fields, preserving the rest */
-	u32_replace_bits(val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
+	u32p_replace_bits(&val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }


