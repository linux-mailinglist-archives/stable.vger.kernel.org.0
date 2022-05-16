Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87C0528EAE
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345729AbiEPToD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345986AbiEPTnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:43:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1121F3FD87;
        Mon, 16 May 2022 12:42:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B3561512;
        Mon, 16 May 2022 19:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE960C34100;
        Mon, 16 May 2022 19:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730144;
        bh=g/KLWhO1p1hT4vFRZBwHmQKiRqu0uGebaUKTKFPxdZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSdjyDYqw41nHZ3UEiMCSjwULZ/5Msal500Ek8obLqk0129gOMatb2YDD+8Qw9bF+
         G/6mctP8kXdyEsBwxOO6VY1NIp3yXocpC7wwu2akDgLhf4NzdcCnv7qxMKETYJNQKe
         Xniun/uICIkq8ydGeXQ9UBwgh8pCobaHaN1GV6oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/43] s390/lcs: fix variable dereferenced before check
Date:   Mon, 16 May 2022 21:36:24 +0200
Message-Id: <20220516193615.110140944@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 671bb35c8e746439f0ed70815968f9a4f20a8deb ]

smatch complains about
drivers/s390/net/lcs.c:1741 lcs_get_control() warn: variable dereferenced before check 'card->dev' (see line 1739)

Fixes: 27eb5ac8f015 ("[PATCH] s390: lcs driver bug fixes and improvements [1/2]")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/lcs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 8f08b0a2917c..4eec7bfb5de9 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1735,10 +1735,11 @@ lcs_get_control(struct lcs_card *card, struct lcs_cmd *cmd)
 			lcs_schedule_recovery(card);
 			break;
 		case LCS_CMD_STOPLAN:
-			pr_warn("Stoplan for %s initiated by LGW\n",
-				card->dev->name);
-			if (card->dev)
+			if (card->dev) {
+				pr_warn("Stoplan for %s initiated by LGW\n",
+					card->dev->name);
 				netif_carrier_off(card->dev);
+			}
 			break;
 		default:
 			LCS_DBF_TEXT(5, trace, "noLGWcmd");
-- 
2.35.1



