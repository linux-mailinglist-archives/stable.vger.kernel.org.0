Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103F74B46DD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244117AbiBNJiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:38:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245519AbiBNJgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A758D6DAB4;
        Mon, 14 Feb 2022 01:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 052B6B80DC6;
        Mon, 14 Feb 2022 09:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E23FC340E9;
        Mon, 14 Feb 2022 09:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831280;
        bh=81aYpI91jq53HB2t3OGicrrculO2wPexrRicI87XbMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMnTnK9ar2fmhqXGj8Yx9mWTafUitwWLl1BBEGc8+Z5Ts4PyFmSp96DZFgoO+n0ww
         D9TBMDd9FoMAeTMcUv3ZptV2iV6IHr0s8Su1lDTRF4R6qHYWEMLFqSgv8hPdQQDbXi
         7Z7uQr4wr+XYaUIc/z3Ke1oBjOGD7MqWgcp5CvuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/49] tipc: rate limit warning for received illegal binding update
Date:   Mon, 14 Feb 2022 10:25:58 +0100
Message-Id: <20220214092449.355989042@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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



