Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDE06AEEA3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbjCGSNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjCGSNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895073D93F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B31DB819BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEEFC433D2;
        Tue,  7 Mar 2023 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212556;
        bh=/ytDEy3X5dEhIzR9KzUS9Hm8wn8uPtZTyseg/Wgk5dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4JZCK9K6wxose7KweT8nqSOuSZO+UswJEkbXR6KjJ3tIyOgWieGKClkDiB52zfOI
         Qlk43gNuI3dfnUOIgVzdeOih/jqaVE0Wam8G2LzION66B021B41KfheTTLRtbGaUjf
         aSAEKv84A2ugsh7bHc+LQw8Z6Py/e3p+WEc/ApH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/885] rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
Date:   Tue,  7 Mar 2023 17:52:36 +0100
Message-Id: <20230307170011.718826046@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 9402bc941823f..f71e1237e03d4 100644
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



