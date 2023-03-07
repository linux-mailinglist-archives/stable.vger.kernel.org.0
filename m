Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4876AF39B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbjCGTHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbjCGTGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:06:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2C7C7083
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:51:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C68E7B819D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79BAC433EF;
        Tue,  7 Mar 2023 18:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215072;
        bh=PEA5Ct73r+dldQmS2xxBcKP9MLwQWjRGymWTGuIiyzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4RMYMzF3qFEf4Pksc0SS355xNJ7Z+GXmxflxj/nA3jtf0xFedJQWLMaWt9cNmf3E
         1JBD3rrxDP0xV/Vns6vgNBfTTo3o3Qjtuakdc4VTRPf4i1rWrdl6rd1ZUHhc9CHo4b
         OE5Fd38thgMQg3RLWwzyuinVKV37kapSMIb/Bz1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/567] rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
Date:   Tue,  7 Mar 2023 17:57:58 +0100
Message-Id: <20230307165912.074875887@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index b363ef13c75ef..8fa3d19c2e667 100644
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



