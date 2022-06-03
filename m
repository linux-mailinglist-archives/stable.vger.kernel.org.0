Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72B153CE2E
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344523AbiFCRjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343573AbiFCRjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:39:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CD15130C;
        Fri,  3 Jun 2022 10:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11CBFB8241D;
        Fri,  3 Jun 2022 17:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0029BC385B8;
        Fri,  3 Jun 2022 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654277982;
        bh=AV9DVa9fzpZL+XXAkhzFaiq2wJMsBMzKbynklE/2+UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SD9sJzIU8NR7v8twWqDgsAZ+TxK1vA1BX/46SZ8XQVVcMV+rb1FXbh9ogEPT7Yacn
         QrKYWKGUjtiGiVP0DaUez2Wxps+RjYk/zM79cGpPzyze0I1tUwWg+VpjBy61yv5vEQ
         Rs4lBXd8lkUXE/Zh/KiwC8hcuATGOeW4ZGmVM9wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/12] net: af_key: check encryption module availability consistency
Date:   Fri,  3 Jun 2022 19:39:27 +0200
Message-Id: <20220603173812.568108883@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173812.524184588@linuxfoundation.org>
References: <20220603173812.524184588@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bartschies <thomas.bartschies@cvk.de>

[ Upstream commit 015c44d7bff3f44d569716117becd570c179ca32 ]

Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel
produces invalid pfkey acquire messages, when these encryption modules are disabled. This
happens because the availability of the algos wasn't checked in all necessary functions.
This patch adds these checks.

Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 776f94ecbfe6..d5dc614af2f9 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2935,7 +2935,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg))
+		if (aalg_tmpl_set(t, aalg) && aalg->available)
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2953,7 +2953,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2964,7 +2964,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg))
+			if (aalg_tmpl_set(t, aalg) && aalg->available)
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.35.1



