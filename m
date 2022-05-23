Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FE9531AFC
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242025AbiEWRka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243644AbiEWRiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6DC6EB02;
        Mon, 23 May 2022 10:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BA6AB811F6;
        Mon, 23 May 2022 17:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27B8C385A9;
        Mon, 23 May 2022 17:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327118;
        bh=jpp7JaAjtpYcJypZTqEMC1XKrOHHdguJX9I0ndKgnbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyI5SN/7MG5bBYR9amS2kfYEyhVdpRgPxhnWWRe04SY4hvBVooR52ArULQ5OmP37q
         4xeXHXx2/BvboZLdXeCxMQpRYozcGL2odx+07l/FZpUNRAzB6kDOmqCI+Mmcsybnzc
         nmZ6cNiyhPeVI7UfXFor0HNvYvjxQiFLTn+DHvc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Frewen <kieran.frewen@morsemicro.com>,
        Bassem Dawood <bassem@morsemicro.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 137/158] cfg80211: retrieve S1G operating channel number
Date:   Mon, 23 May 2022 19:04:54 +0200
Message-Id: <20220523165853.028366562@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Frewen <kieran.frewen@morsemicro.com>

[ Upstream commit e847ffe2d146cfd52980ca688d84358e024a6e70 ]

When retrieving the S1G channel number from IEs, we should retrieve
the operating channel instead of the primary channel. The S1G operation
element specifies the main channel of operation as the oper channel,
unlike for HT and HE which specify their main channel of operation as
the primary channel.

Signed-off-by: Kieran Frewen <kieran.frewen@morsemicro.com>
Signed-off-by: Bassem Dawood <bassem@morsemicro.com>
Link: https://lore.kernel.org/r/20220420041321.3788789-1-kieran.frewen@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 4a6d86432910..6d82bd9eaf8c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1829,7 +1829,7 @@ int cfg80211_get_ies_channel_number(const u8 *ie, size_t ielen,
 		if (tmp && tmp->datalen >= sizeof(struct ieee80211_s1g_oper_ie)) {
 			struct ieee80211_s1g_oper_ie *s1gop = (void *)tmp->data;
 
-			return s1gop->primary_ch;
+			return s1gop->oper_ch;
 		}
 	} else {
 		tmp = cfg80211_find_elem(WLAN_EID_DS_PARAMS, ie, ielen);
-- 
2.35.1



