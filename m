Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C1D4A40B4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244586AbiAaK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:59:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47194 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244170AbiAaK7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:59:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DDD1B82A5C;
        Mon, 31 Jan 2022 10:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F8AC340EF;
        Mon, 31 Jan 2022 10:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626738;
        bh=zK74JLsNNG35iN3KFqzkDIftMt6obJHu9qL2hrEwLkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUr10TtUv4bheFd26/5cfOaJZ62kfDLW9OjU6N1a8ESjXrPizcqvG+A+n15+x2I1K
         0R6NvnBg1JSlYwTM023bMQNji68rRb82IMmWqruMqEiKH4GiB8F/nATpi4An0P73c3
         ws3erCy/9dgSOlnKsHj4nzyYkk6K0yuPkoNyfpDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 23/64] net: sfp: ignore disabled SFP node
Date:   Mon, 31 Jan 2022 11:56:08 +0100
Message-Id: <20220131105216.448654800@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 2148927e6ed43a1667baf7c2ae3e0e05a44b51a0 upstream.

Commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices
and sfp cages") added code which finds SFP bus DT node even if the node
is disabled with status = "disabled". Because of this, when phylink is
created, it ends with non-null .sfp_bus member, even though the SFP
module is not probed (because the node is disabled).

We need to ignore disabled SFP bus node.

Fixes: ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices and sfp cages")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
Signed-off-by: David S. Miller <davem@davemloft.net>
[ backport to 5.4 ]
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -582,6 +582,11 @@ static int phylink_register_sfp(struct p
 		return ret;
 	}
 
+	if (!fwnode_device_is_available(ref.fwnode)) {
+		fwnode_handle_put(ref.fwnode);
+		return 0;
+	}
+
 	pl->sfp_bus = sfp_register_upstream(ref.fwnode, pl, &sfp_phylink_ops);
 	if (!pl->sfp_bus)
 		return -ENOMEM;


