Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A011D6354CF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbiKWJKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237163AbiKWJK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99D5EC0A2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F81D61B56
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1186BC433D6;
        Wed, 23 Nov 2022 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194622;
        bh=GwcMWJ0EPLhLW47wwosOYK46SYIOhNwvIVKoKGOAQBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuSgLwpKhQ56XCM8WXso7vu28YkslujtOmEvT647V9J5m8+71qtKMGRuQA37GQr6b
         66QS2WbWbMKbBYNfxSMeH6SyDzIU2iR/0W+bHFqtKaOf+zhqrco7AjRB7fdgZmXDVu
         a4qYnOYNRmNJ3fx3GWXts5aI4JYxA8I5MNljPcqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akshay Navgire <anavgire@purestorage.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/156] bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer
Date:   Wed, 23 Nov 2022 09:49:32 +0100
Message-Id: <20221123084558.437226071@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Barba <alex.barba@broadcom.com>

[ Upstream commit 02597d39145bb0aa81d04bf39b6a913ce9a9d465 ]

In the bnxt_en driver ndo_rx_flow_steer returns '0' whenever an entry
that we are attempting to steer is already found.  This is not the
correct behavior.  The return code should be the value/index that
corresponds to the entry.  Returning zero all the time causes the
RFS records to be incorrect unless entry '0' is the correct one.  As
flows migrate to different cores this can create entries that are not
correct.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Akshay Navgire <anavgire@purestorage.com>
Signed-off-by: Alex Barba <alex.barba@broadcom.com>
Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5a7d5e7f3b23..d7d7d6421c48 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11182,8 +11182,8 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(fltr, head, hash) {
 		if (bnxt_fltr_match(fltr, new_fltr)) {
+			rc = fltr->sw_id;
 			rcu_read_unlock();
-			rc = 0;
 			goto err_free;
 		}
 	}
-- 
2.35.1



