Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34EC54110F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353346AbiFGTcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356470AbiFGTbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:31:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8455D2B186;
        Tue,  7 Jun 2022 11:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 871B260907;
        Tue,  7 Jun 2022 18:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976BBC385A2;
        Tue,  7 Jun 2022 18:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625544;
        bh=1jivECbvXCO1ttPRE4WjZy2whczZwwcQBj1mjYHVZ/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+fIj2nEIU0tHhV0oQoLUYYys6mUk2NzxqfuRYOy5KqVeFL2JHFUWl1Crx204Ten2
         EL4ijnxdLPS9t/4hfVLOv8umc6GqHFQaQ1MdavRolc4o6jTxaz337pN40B1+IvqquM
         3p+K61Emd/LpswF6gsk+xNdcL/aCPgXCJODU0mbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 056/772] ath11k: Change max no of active probe SSID and BSSID to fw capability
Date:   Tue,  7 Jun 2022 18:54:08 +0200
Message-Id: <20220607164950.691211917@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>

[ Upstream commit 50dc9ce9f80554a88e33b73c30851acf2be36ed3 ]

The maximum number of SSIDs in a for active probe requests is currently
reported as 16 (WLAN_SCAN_PARAMS_MAX_SSID) when registering the driver.
The scan_req_params structure only has the capacity to hold 10 SSIDs.
This leads to a buffer overflow which can be triggered from
wpa_supplicant in userspace. When copying the SSIDs into the
scan_req_params structure in the ath11k_mac_op_hw_scan route, it can
overwrite the extraie pointer.

Firmware supports 16 ssid * 4 bssid, for each ssid 4 bssid combo probe
request will be sent, so totally 64 probe requests supported. So
set both max ssid and bssid to 16 and 4 respectively. Remove the
redundant macros of ssid and bssid.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01300-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220329150221.21907-1-quic_kathirve@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.h | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 2f26ec1a8aa3..8173570975e4 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -3087,9 +3087,6 @@ enum scan_dwelltime_adaptive_mode {
 	SCAN_DWELL_MODE_STATIC = 4
 };
 
-#define WLAN_SCAN_MAX_NUM_SSID          10
-#define WLAN_SCAN_MAX_NUM_BSSID         10
-
 #define WLAN_SSID_MAX_LEN 32
 
 struct element_info {
@@ -3104,7 +3101,6 @@ struct wlan_ssid {
 
 #define WMI_IE_BITMAP_SIZE             8
 
-#define WMI_SCAN_MAX_NUM_SSID                0x0A
 /* prefix used by scan requestor ids on the host */
 #define WMI_HOST_SCAN_REQUESTOR_ID_PREFIX 0xA000
 
@@ -3112,10 +3108,6 @@ struct wlan_ssid {
 /* host cycles through the lower 12 bits to generate ids */
 #define WMI_HOST_SCAN_REQ_ID_PREFIX 0xA000
 
-#define WLAN_SCAN_PARAMS_MAX_SSID    16
-#define WLAN_SCAN_PARAMS_MAX_BSSID   4
-#define WLAN_SCAN_PARAMS_MAX_IE_LEN  256
-
 /* Values lower than this may be refused by some firmware revisions with a scan
  * completion with a timedout reason.
  */
@@ -3311,8 +3303,8 @@ struct scan_req_params {
 	u32 n_probes;
 	u32 *chan_list;
 	u32 notify_scan_events;
-	struct wlan_ssid ssid[WLAN_SCAN_MAX_NUM_SSID];
-	struct wmi_mac_addr bssid_list[WLAN_SCAN_MAX_NUM_BSSID];
+	struct wlan_ssid ssid[WLAN_SCAN_PARAMS_MAX_SSID];
+	struct wmi_mac_addr bssid_list[WLAN_SCAN_PARAMS_MAX_BSSID];
 	struct element_info extraie;
 	struct element_info htcap;
 	struct element_info vhtcap;
-- 
2.35.1



