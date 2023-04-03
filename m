Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0DA6D4A58
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbjDCOqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbjDCOqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F95B280EF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C64ACE12FF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74927C433D2;
        Mon,  3 Apr 2023 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533126;
        bh=JcILdQd0OmJT9lXLLAMILCz+XMba2aucdyQ7Wd+IxDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8mCmgG7th6KHUWlKaWBqnamjtrRKp7GTya7LVI6MuuKKnbRI1Ps42bCnBBts4EBh
         mnYcDbpznpUGbgvQMWO2w4G7ZZsJMwU350TyVOJcClnrwlANAxrC/JrplQ+U4U7fzm
         1D+xQLo6n+Uh0apjNANJ6Ol0EFCzxhUhAwHox0DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Alexander Aring <aahringo@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 065/187] ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()
Date:   Mon,  3 Apr 2023 16:08:30 +0200
Message-Id: <20230403140418.095824431@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 748b2f5e82d17480404b3e2895388fc2925f7caf ]

mac_len is of type unsigned, which can never be less than zero.

	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
	if (mac_len < 0)
		return mac_len;

Change this to type int as ieee802154_hdr_peek_addrs() can return negative
integers, this is found by static analysis with smatch.

Fixes: 6c993779ea1d ("ca8210: fix mac_len negative array access")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 0b0c6c0764fe9..d0b5129439ed6 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1902,10 +1902,9 @@ static int ca8210_skb_tx(
 	struct ca8210_priv  *priv
 )
 {
-	int status;
 	struct ieee802154_hdr header = { };
 	struct secspec secspec;
-	unsigned int mac_len;
+	int mac_len, status;
 
 	dev_dbg(&priv->spi->dev, "%s called\n", __func__);
 
-- 
2.39.2



