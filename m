Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E335489FC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381976AbiFMOQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382980AbiFMOPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:15:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDBB9B1B2;
        Mon, 13 Jun 2022 04:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C112B80EDD;
        Mon, 13 Jun 2022 11:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E48C34114;
        Mon, 13 Jun 2022 11:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120559;
        bh=LScDcHeqMPl2Kp8KDh49fGvlTXdrmkknJXbg85f/YUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3M2KYtPfPxYPO071CjglnKRLIBw0JdD2fFcUDVvyacPiHLt/726H9Qq6FR0F9l3t
         bulLR12A5dV+S2eSZVjcu5qkWqzGFVsnq/kiBeZJ4FoCoq3WqC47NA/iclDg2dvX9V
         dHKWBYRNxsRvEQmfCTjECJrBDg96f5zAm55OqOZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 077/298] amt: fix return value of amt_update_handler()
Date:   Mon, 13 Jun 2022 12:09:31 +0200
Message-Id: <20220613094927.282335867@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index fb774d568baa..6205282a09e5 100644
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



