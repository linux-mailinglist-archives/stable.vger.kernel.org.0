Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78BE4E7792
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349311AbiCYP2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377360AbiCYPYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27EBE6C6E;
        Fri, 25 Mar 2022 08:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86FED60A1B;
        Fri, 25 Mar 2022 15:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D9AC340E9;
        Fri, 25 Mar 2022 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221470;
        bh=FQ1u8yPWxi0An71a6D9PM9mhOZjP8Swoix1nujNZoeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6A1EMKL4SC0vSZNZ0Zx+FdLUEAvDGmz63t2WswyISON5sW8V6BhfPnu7mqc0k2G6
         3yalkomspoPPXb1fnMV/PmAWcx0w52a2TNjpigXEUUZmXRWX/4y0yo6nTtRDo1z+ki
         0RMVj4IBtm80VbM6FHLR/cq118ACLbm8xm973V/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 5.16 35/37] wcn36xx: Differentiate wcn3660 from wcn3620
Date:   Fri, 25 Mar 2022 16:14:45 +0100
Message-Id: <20220325150421.050879289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 98d504a82cc75840bec8e3c6ae0e4f411921962b upstream.

The spread of capability between the three WiFi silicon parts wcn36xx
supports is:

wcn3620 - 802.11 a/b/g
wcn3660 - 802.11 a/b/g/n
wcn3680 - 802.11 a/b/g/n/ac

We currently treat wcn3660 as wcn3620 thus limiting it to 2GHz channels.
Fix this regression by ensuring we differentiate between all three parts.

Fixes: 8490987bdb9a ("wcn36xx: Hook and identify RF_IRIS_WCN3680")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220125004046.4058284-1-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    |    3 +++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1483,6 +1483,9 @@ static int wcn36xx_platform_get_resource
 	if (iris_node) {
 		if (of_device_is_compatible(iris_node, "qcom,wcn3620"))
 			wcn->rf_id = RF_IRIS_WCN3620;
+		if (of_device_is_compatible(iris_node, "qcom,wcn3660") ||
+		    of_device_is_compatible(iris_node, "qcom,wcn3660b"))
+			wcn->rf_id = RF_IRIS_WCN3660;
 		if (of_device_is_compatible(iris_node, "qcom,wcn3680"))
 			wcn->rf_id = RF_IRIS_WCN3680;
 		of_node_put(iris_node);
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -97,6 +97,7 @@ enum wcn36xx_ampdu_state {
 
 #define RF_UNKNOWN	0x0000
 #define RF_IRIS_WCN3620	0x3620
+#define RF_IRIS_WCN3660	0x3660
 #define RF_IRIS_WCN3680	0x3680
 
 static inline void buff_to_be(u32 *buf, size_t len)


