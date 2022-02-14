Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BEE4B4B14
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbiBNKNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:13:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345407AbiBNKLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:11:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E767652CE;
        Mon, 14 Feb 2022 01:50:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D656B80DC4;
        Mon, 14 Feb 2022 09:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456C5C340E9;
        Mon, 14 Feb 2022 09:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832238;
        bh=htPT7ZJRwec3btt28+wtKwzLxrimdxWXFf2+yFhzDzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnFBzE+qtT83tbrfSueEK7rWttOV+AwCEL5UQgIByYLTCiBaN6Q+ByvfMhwdUiHeD
         VHwr2tumBjvgLmi6Rrgi8Utmo3lab7BihcPrF2+b6qehmSfMKodRVimVf5zSfv5fqg
         9rKI78Jur3TG2JdTTnuTqek+cKbwQrn1+W2N2TJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/172] tipc: rate limit warning for received illegal binding update
Date:   Mon, 14 Feb 2022 10:26:21 +0100
Message-Id: <20220214092510.665360710@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index bda902caa8147..8267b751a526a 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -313,7 +313,7 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 		pr_warn_ratelimited("Failed to remove binding %u,%u from %u\n",
 				    ua.sr.type, ua.sr.lower, node);
 	} else {
-		pr_warn("Unrecognized name table message received\n");
+		pr_warn_ratelimited("Unknown name table message received\n");
 	}
 	return false;
 }
-- 
2.34.1



