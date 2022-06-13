Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697DA5498A6
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377496AbiFMNkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378087AbiFMNhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:37:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1E83630D;
        Mon, 13 Jun 2022 04:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACE5761225;
        Mon, 13 Jun 2022 11:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CB4C3411C;
        Mon, 13 Jun 2022 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119642;
        bh=uo0lwWJaTQsbH8CNcVD3Nc5hC4tDjxOrZxt2j38czqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKGIA348tCBdukOZO2D20sOQ1Qb3HSARkDKzhO4iRbOgq+zxkNjQL3IZWJjZo+EsQ
         vdtr8ZFSGegbuh+EqLqZk2dCFT9OIZekFmtfxD/8wn3x3zh39DetmZ6fnmY40UBmtR
         S9vBbUFnvVCikY5Kdv/tGncpXeFNNTCER5kDQzHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 086/339] amt: fix return value of amt_update_handler()
Date:   Mon, 13 Jun 2022 12:08:31 +0200
Message-Id: <20220613094929.125482154@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit ac1dbf55981b88d64312858ea06e3e63001f085d ]

If a relay receives an update message, it lookup a tunnel.
and if there is no tunnel for that message, it should be treated
as an error, not a success.
But amt_update_handler() returns false, which means success.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index de4ea518c793..d376ed89f836 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2423,7 +2423,7 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 		}
 	}
 
-	return false;
+	return true;
 
 report:
 	iph = ip_hdr(skb);
-- 
2.35.1



