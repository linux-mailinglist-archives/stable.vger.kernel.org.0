Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F3C4B4717
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244533AbiBNJl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:41:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245038AbiBNJlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0492AA1A3;
        Mon, 14 Feb 2022 01:36:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 884016116D;
        Mon, 14 Feb 2022 09:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50893C340EF;
        Mon, 14 Feb 2022 09:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831418;
        bh=81aYpI91jq53HB2t3OGicrrculO2wPexrRicI87XbMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8BPlj/k1bxr06aij+DJHWoqI2VBrWqTxlxjP7CF5EEoGpeJ4+TyZF8CQAA2BkLOF
         LmennnIKjua7gf0pL/4dPtSdK8cFQ4EQDfRLXPO/IMvk5TthOLEJW1JPwUOFmWGhhy
         e/b3oP4DG2lOlA0mvKXfOGxlDI/xWLOymXzjSCko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/71] tipc: rate limit warning for received illegal binding update
Date:   Mon, 14 Feb 2022 10:26:16 +0100
Message-Id: <20220214092453.666682678@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

[ Upstream commit c7223d687758462826a20e9735305d55bb874c70 ]

It would be easy to craft a message containing an illegal binding table
update operation. This is handled correctly by the code, but the
corresponding warning printout is not rate limited as is should be.
We fix this now.

Fixes: b97bf3fd8f6a ("[TIPC] Initial merge")
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/name_distr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 836e629e8f4ab..661bc2551a0a2 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -290,7 +290,7 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 		pr_warn_ratelimited("Failed to remove binding %u,%u from %x\n",
 				    type, lower, node);
 	} else {
-		pr_warn("Unrecognized name table message received\n");
+		pr_warn_ratelimited("Unknown name table message received\n");
 	}
 	return false;
 }
-- 
2.34.1



