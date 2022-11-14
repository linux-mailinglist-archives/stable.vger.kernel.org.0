Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADC9627F26
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbiKNMz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbiKNMz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:55:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66D127CE0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82A3561181
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8203AC433D7;
        Mon, 14 Nov 2022 12:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430554;
        bh=0n7V6TdNcHSFJE3fjdUH9VzsNkB6/8CxOOfs+P+oK+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewUrMKfdIfylC/Se49eGqWzSzW/a1vk4CsCl33JD7w3HrLvU+b34SZPXWqrAxkI4S
         Ox5l/ZjxDCjNYhnR8VAg+boWeECsR+S7l8sPmIODo3vQG0KKSHItJ1lKzxtszijxrB
         Kj5HNMFmn+5QnICsJCljDfLCguDBKwjbPYI/U+PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akshay Navgire <anavgire@purestorage.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/131] bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer
Date:   Mon, 14 Nov 2022 13:45:01 +0100
Message-Id: <20221114124450.047805085@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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
index a6ca7ba5276c..db1864a3f64a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12605,8 +12605,8 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
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



