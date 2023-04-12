Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003916DEE86
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjDLImN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjDLIl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E5B171F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6304563054
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B20C433EF;
        Wed, 12 Apr 2023 08:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288872;
        bh=us7ZqyftedUPyk3U5IsyXxtRTU4kkJDYkjIYGcsJeWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7SRz/3cBtJ3oCy/tTHFybacm9Eh94YzrEwd2QIgo/gf29xDt2aNdN/PrSlMR4FPy
         HjT5fCW3xXl4meP5DL3QneZouc2RtOh71ipSYKXsmxGaghL6E4DwGUBDNqgfKqfSMo
         PDCH+3kPzM6W9Yu2i0sA8lDg0TrPJ7aXiFcaHkX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ryder Lee <ryder.lee@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/164] wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()
Date:   Wed, 12 Apr 2023 10:32:22 +0200
Message-Id: <20230412082837.752189234@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit dd01579e5ed922dcfcb8fec53fa03b81c7649a04 ]

Here should return the size of ieee80211_eht_cap_elem_fixed, so fix it.

Fixes: 820acc810fb6 ("mac80211: Add EHT capabilities to association/probe request")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://lore.kernel.org/r/06c13635fc03bcff58a647b8e03e9f01a74294bd.1679935259.git.ryder.lee@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ed53c51bbc321..0785d9393e718 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4785,7 +4785,7 @@ u8 ieee80211_ie_len_eht_cap(struct ieee80211_sub_if_data *sdata, u8 iftype)
 				       &eht_cap->eht_cap_elem,
 				       is_ap);
 	return 2 + 1 +
-	       sizeof(he_cap->he_cap_elem) + n +
+	       sizeof(eht_cap->eht_cap_elem) + n +
 	       ieee80211_eht_ppe_size(eht_cap->eht_ppe_thres[0],
 				      eht_cap->eht_cap_elem.phy_cap_info);
 	return 0;
-- 
2.39.2



