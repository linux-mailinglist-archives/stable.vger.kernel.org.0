Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E888D80D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfHNQ1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:27:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37917 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727524AbfHNQ1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 12:27:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C7E721A7B;
        Wed, 14 Aug 2019 12:27:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 12:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=LPd2Ci
        YOMjO4W3OikazfqXx0sCtLlayIWylZ6PUdCRg=; b=mg0038tx9PKZEhJOHM7L03
        E5B0YZYjwxIs4V7vpSX5tfcy+wUmge91Yi4lL1bfrBmvfgkvgbkyHMa+PJcqMQbO
        aNc2XLhzD94eMlsR7gyY+4vwpIhMWAoaEMVic0rtGKuMd1eb6Lfk2UZvnyxP0BQR
        JGd7TMFpP8ZkEgY3ZXbo8aUezHLhIOMqsyT1lu3sV0eRBn0FaAIrD6j845RcmaJq
        kgEa1n1YryOMiOQZI3W9/mxghHGTb7dyAoCh8HbQhqcLM+1buIy8MVCZK/2veM09
        6PHViK0x5rJXgN+JRqmvziGle3VgH2bj8+aeG4TLI7bdPOd1VkBW7dnInSkFQdIw
        ==
X-ME-Sender: <xms:ejZUXYi9O6b_1JcXQGi8my7MJd71PsCNsOMAgBF9--4RjfEblylkVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:ejZUXTs4g3mIngUDjEPoGvumPSFhv9w0caX-WOfKSDcxGIYXhlGYTw>
    <xmx:ejZUXdkgAATSBSuK31mFw3msQAzXU464Buh0u1t4EDUr6I-tSh2YIg>
    <xmx:ejZUXfpkwduO-5gTdOxHPJesDrpWk3P5xyW5ea28YsJA7r7Qd-lkRA>
    <xmx:ejZUXaYefg0Nodz7s2TR5augzkQMmx-hxd9etqZRFA3x2qY4Rlj6jA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C1DA58005C;
        Wed, 14 Aug 2019 12:27:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mwifiex: fix 802.11n/WPA detection" failed to apply to 4.4-stable tree
To:     briannorris@chromium.org, kvalo@codeaurora.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 14 Aug 2019 18:27:35 +0200
Message-ID: <1565800055929@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From df612421fe2566654047769c6852ffae1a31df16 Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Wed, 24 Jul 2019 12:46:34 -0700
Subject: [PATCH] mwifiex: fix 802.11n/WPA detection

Commit 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant
vendor IEs") adjusted the ieee_types_vendor_header struct, which
inadvertently messed up the offsets used in
mwifiex_is_wpa_oui_present(). Add that offset back in, mirroring
mwifiex_is_rsn_oui_present().

As it stands, commit 63d7ef36103d breaks compatibility with WPA (not
WPA2) 802.11n networks, since we hit the "info: Disable 11n if AES is
not supported by AP" case in mwifiex_is_network_compatible().

Fixes: 63d7ef36103d ("mwifiex: Don't abort on small, spec-compliant vendor IEs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 3e442c7f7882..095837fba300 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -124,6 +124,7 @@ enum {
 
 #define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
 
+#define WPA_GTK_OUI_OFFSET				2
 #define RSN_GTK_OUI_OFFSET				2
 
 #define MWIFIEX_OUI_NOT_PRESENT			0
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 0d6d41727037..21dda385f6c6 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -181,7 +181,8 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
-		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
+		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
+					    WPA_GTK_OUI_OFFSET);
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
 		if (ret)

