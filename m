Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1149D205CED
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388542AbgFWUGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388538AbgFWUGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 339262078A;
        Tue, 23 Jun 2020 20:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942813;
        bh=IdCbGn+BD/zSCajYpboxueiJwEpe9JU+/3rkeyZ6MkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4oPIOs3bIojw3cLPUurRYzH2bbqFkcGfcKyXeDz2LHs/VBqZkt23UAhm0gu1YIqH
         bE98XD4IjcOjkPdFkHoOZhu5450CF+0Yo8OIOQOYPzSI/sVzFD68u8We/HmEYhtHEr
         XJrCIvEVAKf+wCuK+QEqe9cbHeKBshqbFIW+ViMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 146/477] of: property: Fix create device links for all child-supplier dependencies
Date:   Tue, 23 Jun 2020 21:52:23 +0200
Message-Id: <20200623195414.502212413@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit ed3655729182a59b9bef1b564c6fc2dcbbbe954e ]

Upon adding a new device from a DT node, we scan its properties and its
children's properties in order to create a consumer/supplier
relationship between the device and the property provider.

That said, it's possible for some of the node's children to be disabled,
which will create links that'll never be fulfilled.

To get around this, use the for_each_available_child_of_node() function
instead of for_each_available_node() when iterating over the node's
children.

Fixes: d4387cd11741 ("of: property: Create device links for all child-supplier depencencies")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index b4916dcc9e725..a8c2b13521b27 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1296,7 +1296,7 @@ static int of_link_to_suppliers(struct device *dev,
 		if (of_link_property(dev, con_np, p->name))
 			ret = -ENODEV;
 
-	for_each_child_of_node(con_np, child)
+	for_each_available_child_of_node(con_np, child)
 		if (of_link_to_suppliers(dev, child) && !ret)
 			ret = -EAGAIN;
 
-- 
2.25.1



