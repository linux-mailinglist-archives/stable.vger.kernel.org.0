Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9551B604869
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiJSN4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbiJSNzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:55:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFFC170DF2;
        Wed, 19 Oct 2022 06:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F083B822E8;
        Wed, 19 Oct 2022 08:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7802CC433D6;
        Wed, 19 Oct 2022 08:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169341;
        bh=Y4pMd06s9Gr1I5Zfl0sgVaB4qlD7jgp/s7Joa+5BCcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hH+EehRrRSY/OBD9e1i+Jjf6oshllD8tBynvU57Agn/hyd4CMkYf07Fxr8htodOfg
         tAXfYEfDexeDArnTkPjv59lChOtUPPMQhCnnBlR7fBAh29HS1Tvbgv8dlDapUR1p3j
         lSpAF20i9jIcQ9UVrF0IvFFx2sFrp9CIrZfewrMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 241/862] wifi: mac80211: mlme: dont add empty EML capabilities
Date:   Wed, 19 Oct 2022 10:25:28 +0200
Message-Id: <20221019083300.673827588@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 1cb3cf372abe4a0d16620d2b1201de0e291a6c58 ]

Draft P802.11be_D2.1, section 35.3.17 states that the EML Capabilities
Field shouldn't be included in case the device doesn't have support for
EMLSR or EMLMR.

Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1e9cb4be6ed3..76ae6f03d77e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1220,14 +1220,21 @@ static void ieee80211_assoc_add_ml_elem(struct ieee80211_sub_if_data *sdata,
 	ml_elem = skb_put(skb, sizeof(*ml_elem));
 	ml_elem->control =
 		cpu_to_le16(IEEE80211_ML_CONTROL_TYPE_BASIC |
-			    IEEE80211_MLC_BASIC_PRES_EML_CAPA |
 			    IEEE80211_MLC_BASIC_PRES_MLD_CAPA_OP);
 	common = skb_put(skb, sizeof(*common));
 	common->len = sizeof(*common) +
-		      2 + /* EML capabilities */
 		      2;  /* MLD capa/ops */
 	memcpy(common->mld_mac_addr, sdata->vif.addr, ETH_ALEN);
-	skb_put_data(skb, &eml_capa, sizeof(eml_capa));
+
+	/* add EML_CAPA only if needed, see Draft P802.11be_D2.1, 35.3.17 */
+	if (eml_capa &
+	    cpu_to_le16((IEEE80211_EML_CAP_EMLSR_SUPP |
+			 IEEE80211_EML_CAP_EMLMR_SUPPORT))) {
+		common->len += 2; /* EML capabilities */
+		ml_elem->control |=
+			cpu_to_le16(IEEE80211_MLC_BASIC_PRES_EML_CAPA);
+		skb_put_data(skb, &eml_capa, sizeof(eml_capa));
+	}
 	/* need indication from userspace to support this */
 	mld_capa_ops &= ~cpu_to_le16(IEEE80211_MLD_CAP_OP_TID_TO_LINK_MAP_NEG_SUPP);
 	skb_put_data(skb, &mld_capa_ops, sizeof(mld_capa_ops));
-- 
2.35.1



