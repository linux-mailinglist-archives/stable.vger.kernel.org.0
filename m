Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FB8528EFB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245560AbiEPToW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346327AbiEPTmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3972C40E62;
        Mon, 16 May 2022 12:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B96F761518;
        Mon, 16 May 2022 19:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2E0C34115;
        Mon, 16 May 2022 19:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730035;
        bh=YSaILP1z9ijbzuJFqGxg+JHYIfGmGEoPCKnEMhv7FMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiXMI/jbYxcm+EhQIC51Z6LLF2iIxGUjvEWzKItbZUR+KrC4R8S5Ortcew54P4Bs7
         Jk+jmorwcOF9gfw+eUAjp+PP9TlZ0mTvG9YNHdJJCrpBrk3z9W481zMjVZ/DqFdTMq
         2rotQQGLdnddAHP2fdruoG5n6BuQmVzhqV4rOBAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/32] s390/lcs: fix variable dereferenced before check
Date:   Mon, 16 May 2022 21:36:24 +0200
Message-Id: <20220516193615.082471011@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 2d9fe7e4ee40..d8f99ff53a94 100644
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



