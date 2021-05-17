Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D83383510
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbhEQPPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242941AbhEQPMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90E0161C31;
        Mon, 17 May 2021 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261884;
        bh=lmCl/8+UbLLfBdAII2ABQDwTMsu3Sc1/051k2dkBo2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2uHkqvuFqcRaE2McACV2jpEqFOtS6hy/lyBq3cM0fF3b3e1QvFtYVT1l7VO1J+5p
         EacYCvmFGPfPHuT8ZuBIT8MpnqrS89JMRrv2oqMuA8c3cesIBqcezZZgTwNbVQep5x
         3vilUFcAqqAm+S8qL0MY2k8/JYjg7xn/fH84TbYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Gibson <leegib@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/289] qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth
Date:   Mon, 17 May 2021 16:00:05 +0200
Message-Id: <20210517140307.881242559@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Gibson <leegib@gmail.com>

[ Upstream commit 130f634da1af649205f4a3dd86cbe5c126b57914 ]

Function qtnf_event_handle_external_auth calls memcpy without
checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210419145842.345787-1-leegib@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index c775c177933b..8dc80574d08d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -570,8 +570,10 @@ qtnf_event_handle_external_auth(struct qtnf_vif *vif,
 		return 0;
 
 	if (ev->ssid_len) {
-		memcpy(auth.ssid.ssid, ev->ssid, ev->ssid_len);
-		auth.ssid.ssid_len = ev->ssid_len;
+		int len = clamp_val(ev->ssid_len, 0, IEEE80211_MAX_SSID_LEN);
+
+		memcpy(auth.ssid.ssid, ev->ssid, len);
+		auth.ssid.ssid_len = len;
 	}
 
 	auth.key_mgmt_suite = le32_to_cpu(ev->akm_suite);
-- 
2.30.2



