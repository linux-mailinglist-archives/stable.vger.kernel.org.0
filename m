Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE26249A07B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384123AbiAXXHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843730AbiAXXFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:05:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E035CC02B77E;
        Mon, 24 Jan 2022 13:16:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8836BB811A2;
        Mon, 24 Jan 2022 21:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02CBC340E4;
        Mon, 24 Jan 2022 21:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058994;
        bh=n+2oQiECCDibeXeXVuzVRofAl5ID7Qq6aThu6u/Ccas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpw+kscnvqiOeTJkcSs9J7R+i1V9wUtYgJpfxldzVuzxDH3GCyCmQymvwSRvljLgZ
         ciBM576y4y7wAEe1ITg9NIot4FLUKTXHbYM2sgNPKVIOB/NpTUgR6kM0YGKNbtKnya
         cVXWgvYagraN4iYiR7B8+sm7A5wmbN/J0bBcz5U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0442/1039] amt: fix wrong return type of amt_send_membership_update()
Date:   Mon, 24 Jan 2022 19:37:11 +0100
Message-Id: <20220124184140.152117560@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit dd3ca4c5184ea98e40acb8eb293d85b88ea04ee2 ]

amt_send_membership_update() would return -1 but it's return type is bool.
So, it should be used TRUE instead of -1.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20220109163702.6331-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index b732ee9a50ef9..d3a9dda6c7286 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -1106,7 +1106,7 @@ static bool amt_send_membership_query(struct amt_dev *amt,
 	rt = ip_route_output_key(amt->net, &fl4);
 	if (IS_ERR(rt)) {
 		netdev_dbg(amt->dev, "no route to %pI4\n", &tunnel->ip4);
-		return -1;
+		return true;
 	}
 
 	amtmq		= skb_push(skb, sizeof(*amtmq));
-- 
2.34.1



