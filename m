Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E8229C13B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818780AbgJ0RXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780361AbgJ0Oyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C7DB2071A;
        Tue, 27 Oct 2020 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810479;
        bh=m2sAscp8GZC4PsGIVLYG/JfZpBDCbWvs3AfntdcUT8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGCBn6wBX45KLAW2U/yLteCw/G5sRBlZp3MReARd3RS6vTNPvjvPk7gYkP2/dVtOs
         wF26Xf105Sz969iAKWfUCAd79A0nFxNxlk+1+v5UJsn4XcchCqb0j87zoPcFcMcDH+
         T6l1Na4Ujb1J21vwlMcXcsB+PllVE4KuOfynlplg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Markus Theil <markus.theil@tu-ilmenau.de>,
        John Deere <24601deerej@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 154/633] ath10k: provide survey info as accumulated data
Date:   Tue, 27 Oct 2020 14:48:17 +0100
Message-Id: <20201027135529.916383470@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkateswara Naralasetty <vnaralas@codeaurora.org>

[ Upstream commit 720e5c03e5cb26d33d97f55192b791bb48478aa5 ]

It is expected that the returned counters by .get_survey are monotonic
increasing. But the data from ath10k gets reset to zero regularly. Channel
active/busy time are then showing incorrect values (less than previous or
sometimes zero) for the currently active channel during successive survey
dump commands.

example:

  $ iw dev wlan0 survey dump
  Survey data from wlan0
  	frequency:                      5180 MHz [in use]
  	channel active time:            54995 ms
  	channel busy time:              432 ms
  	channel receive time:           0 ms
  	channel transmit time:          59 ms
  ...

  $ iw dev wlan0 survey dump
  Survey data from wlan0
  	frequency:                      5180 MHz [in use]
  	channel active time:            32592 ms
  	channel busy time:              254 ms
  	channel receive time:           0 ms
  	channel transmit time:          0 ms
  ...

The correct way to handle this is to use the non-clearing
WMI_BSS_SURVEY_REQ_TYPE_READ wmi_bss_survey_req_type. The firmware will
then accumulate the survey data and handle wrap arounds.

Tested-on: QCA9984 hw1.0 10.4-3.5.3-00057
Tested-on: QCA988X hw2.0 10.2.4-1.0-00047
Tested-on: QCA9888 hw2.0 10.4-3.9.0.2-00024
Tested-on: QCA4019 hw1.0 10.4-3.6-00140

Fixes: fa7937e3d5c2 ("ath10k: update bss channel survey information")
Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Tested-by: Markus Theil <markus.theil@tu-ilmenau.de>
Tested-by: John Deere <24601deerej@gmail.com>
[sven@narfation.org: adjust commit message]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1592232686-28712-1-git-send-email-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 919d15584d4a2..77daca67a8e14 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7283,7 +7283,7 @@ ath10k_mac_update_bss_chan_survey(struct ath10k *ar,
 				  struct ieee80211_channel *channel)
 {
 	int ret;
-	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR;
+	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-- 
2.25.1



