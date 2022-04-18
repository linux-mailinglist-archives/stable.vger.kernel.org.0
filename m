Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C0F5057B6
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiDRNz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343815AbiDRNy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:54:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2FB48887;
        Mon, 18 Apr 2022 06:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4919C60B3C;
        Mon, 18 Apr 2022 13:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40235C385AB;
        Mon, 18 Apr 2022 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287019;
        bh=pUGtlsi/3YpPfmSZEWEbmrqmUcAyVelXqsO2JwfRcZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBKKIyHUsAYIx0ZDvoaZQbW/XPfJM7C6beQG6Z+b5YoYB7uSzhWMuO4Z3hymsPcFK
         KS6Ty5y1WyIksPtmSwxwps6VgJF4es5eMbGy/9u0fue9TPtgJ0Zaf+oBuaWJRDCwBh
         ahoA2H1tS8GYPgumjQVFv9k+hp5g8P+/rg/vZApc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 4.9 032/218] carl9170: fix missing bit-wise or operator for tx_params
Date:   Mon, 18 Apr 2022 14:11:38 +0200
Message-Id: <20220418121200.329028354@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Colin Ian King <colin.i.king@gmail.com>

commit 02a95374b5eebdbd3b6413fd7ddec151d2ea75a1 upstream.

Currently tx_params is being re-assigned with a new value and the
previous setting IEEE80211_HT_MCS_TX_RX_DIFF is being overwritten.
The assignment operator is incorrect, the original intent was to
bit-wise or the value in. Fix this by replacing the = operator
with |= instead.

Kudos to Christian Lamparter for suggesting the correct fix.

Fixes: fe8ee9ad80b2 ("carl9170: mac80211 glue and command interface")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: <Stable@vger.kernel.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220125004406.344422-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/carl9170/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1920,7 +1920,7 @@ static int carl9170_parse_eeprom(struct
 		WARN_ON(!(tx_streams >= 1 && tx_streams <=
 			IEEE80211_HT_MCS_TX_MAX_STREAMS));
 
-		tx_params = (tx_streams - 1) <<
+		tx_params |= (tx_streams - 1) <<
 			    IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 
 		carl9170_band_2GHz.ht_cap.mcs.tx_params |= tx_params;


