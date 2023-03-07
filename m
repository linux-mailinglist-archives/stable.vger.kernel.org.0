Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852136AEEB6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjCGSPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjCGSOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1630A3B4C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BC35B819BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC10DC433EF;
        Tue,  7 Mar 2023 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212611;
        bh=kVM4jPj/0QexJcwFCg1Jj1jedA362i86xw3x0MwcclQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsyVZ7Jz4kIoOC14pOWzaTLi6wyIMCe+JNfSPIi/0dGpCRk7d6qSypNT8/03My3Mh
         ZIKQzbl+Ci9RF14rbVgbk9sEUnYtKZDLSMSKNKF8Tg4aSDwNXfTczfFp5NihJUx9Mo
         KvPrIrgm3lKLf4No8eoQsr4CDqF/HTt0GobC0kyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/885] wifi: mac80211: Dont translate MLD addresses for multicast
Date:   Tue,  7 Mar 2023 17:52:52 +0100
Message-Id: <20230307170012.351896646@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit daf8fb4295dccc032515cdc1bd3873370063542b ]

MLD address translation should be done only for individually addressed
frames. Otherwise, AAD calculation would be wrong and the decryption
would fail.

Fixes: e66b7920aa5ac ("wifi: mac80211: fix initialization of rx->link and rx->link_sta")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Link: https://lore.kernel.org/r/20230214101048.792414-1-andrei.otcheretianski@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f9604dc182a87..08e01bddc9fb2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4861,7 +4861,8 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		hdr = (struct ieee80211_hdr *)rx->skb->data;
 	}
 
-	if (unlikely(rx->sta && rx->sta->sta.mlo)) {
+	if (unlikely(rx->sta && rx->sta->sta.mlo) &&
+	    is_unicast_ether_addr(hdr->addr1)) {
 		/* translate to MLD addresses */
 		if (ether_addr_equal(link->conf->addr, hdr->addr1))
 			ether_addr_copy(hdr->addr1, rx->sdata->vif.addr);
-- 
2.39.2



