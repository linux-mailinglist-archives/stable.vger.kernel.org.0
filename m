Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28856B4522
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjCJObS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjCJOa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:30:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510E3121405
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC15A6195C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6D5C433EF;
        Fri, 10 Mar 2023 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458598;
        bh=AMTNLbKu3mTpJ10XBUDvWgsu9qwR0xPi015YckndyLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOVkwMx9NDM2MDX+OyiT1FJI2ETd3aDVBEVASKROnIT6xVUpZp6uwEHXg3tWl93WR
         JmrETzITr6v+Z3M2MgbMmkIlCHyYyYQnceKgnR2ivHKv/jStwlNaWTjcSaeawVWS08
         LOl9LEe8A3af6zFnZhYTCpmz6FsfJTdUG319wUI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/357] rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
Date:   Fri, 10 Mar 2023 14:36:08 +0100
Message-Id: <20230310133737.469811356@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 68762148d1b011d47bc2ceed7321739b5aea1e63 ]

rds_rm_zerocopy_callback() uses list_add_tail() with swapped
arguments. This links the list head with the new entry, losing
the references to the remaining part of the list.

Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index be6a0a073b12a..75043742d243c 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -118,7 +118,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	ck = &info->zcookies;
 	memset(ck, 0, sizeof(*ck));
 	WARN_ON(!rds_zcookie_add(info, cookie));
-	list_add_tail(&q->zcookie_head, &info->rs_zcookie_next);
+	list_add_tail(&info->rs_zcookie_next, &q->zcookie_head);
 
 	spin_unlock_irqrestore(&q->lock, flags);
 	/* caller invokes rds_wake_sk_sleep() */
-- 
2.39.2



