Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1104F31A8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344943AbiDEKkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiDEJlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36359BAB8D;
        Tue,  5 Apr 2022 02:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C59AF61368;
        Tue,  5 Apr 2022 09:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44D7C385A0;
        Tue,  5 Apr 2022 09:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150709;
        bh=AXM6EIGv3cMnti0AXeqKdjQ/tXW2ov+kO9R4rZJX9+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLkjt0DVIJmFQ5vGobsQTIX320gqI0qeLSYgE/wQFdXoF1zJbOKqjkGfCBdMi07uf
         plkbxUcpUqAHgcGVD0ZDG29L2uqpaYcJ2cf7ldO5fD282yHR+aN2Pp8nxh+yXCJIge
         XLNJ61ORVzXft99xIviBRMIcbQgCI8eeK8meQiks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 5.15 152/913] carl9170: fix missing bit-wise or operator for tx_params
Date:   Tue,  5 Apr 2022 09:20:14 +0200
Message-Id: <20220405070344.394137918@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1915,7 +1915,7 @@ static int carl9170_parse_eeprom(struct
 		WARN_ON(!(tx_streams >= 1 && tx_streams <=
 			IEEE80211_HT_MCS_TX_MAX_STREAMS));
 
-		tx_params = (tx_streams - 1) <<
+		tx_params |= (tx_streams - 1) <<
 			    IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 
 		carl9170_band_2GHz.ht_cap.mcs.tx_params |= tx_params;


