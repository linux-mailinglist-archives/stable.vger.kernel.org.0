Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6F25BAAA4
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiIPK2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiIPK1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:27:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E348B3B0E;
        Fri, 16 Sep 2022 03:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1580B82562;
        Fri, 16 Sep 2022 10:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B83C433D6;
        Fri, 16 Sep 2022 10:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323317;
        bh=yxmTmAmQYOY0Y1XhFJJ91Ijes9f9h/iULVvKrO+XC0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yinpOKHSEoNCbtF1JdRY7kK2iis/YPULe+WbtbL6psgcmFy/MBYB5nPG2gnHVCY5p
         A9aKTgBN+gz/vG1m96XjFO+Vcc1/50m92hPcRNq3qd4Cyplj2JSxCHXrs4tRryaepT
         2ySe6nSEJQnj0wd3pb9x5I4ETzU2fgWEGwVGmYn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 28/38] net: dsa: hellcreek: Print warning only once
Date:   Fri, 16 Sep 2022 12:09:02 +0200
Message-Id: <20220916100449.646918765@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 52267ce25f60f37ae40ccbca0b21328ebae5ae75 ]

In case the source port cannot be decoded, print the warning only once. This
still brings attention to the user and does not spam the logs at the same time.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220830163448.8921-1-kurt@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index eb204ad36eeec..846588c0070a5 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -45,7 +45,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev) {
-		netdev_warn(dev, "Failed to get source port: %d\n", port);
+		netdev_warn_once(dev, "Failed to get source port: %d\n", port);
 		return NULL;
 	}
 
-- 
2.35.1



