Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B65EEEB1
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389576AbfKDWDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:03:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387972AbfKDWDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:40 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D8E205C9;
        Mon,  4 Nov 2019 22:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905018;
        bh=hXh3Eq5I81mqQAHVTeD/K1pcz2p9HTdgos6iBg4pz9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYKrY4v9vRR0wx2cJfWZHJyI5RSZc80y/XXyPky/v5C6ia3S7TFzripwhiII/q9cS
         UuPWjkETYjBgYwU/x9oyHV2H5lqMkQ+FE1Jp5rpm+CEwpUlZrOg1lJSghvg/UVRglf
         cXSIEl2K3jOX2tKQeBLsDVxiRbR7hpSS4v86z2RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Waisman <nico@semmle.com>,
        Laura Abbott <labbott@redhat.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 130/149] rtlwifi: Fix potential overflow on P2P code
Date:   Mon,  4 Nov 2019 22:45:23 +0100
Message-Id: <20191104212145.811534184@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

commit 8c55dedb795be8ec0cf488f98c03a1c2176f7fb1 upstream.

Nicolas Waisman noticed that even though noa_len is checked for
a compatible length it's still possible to overrun the buffers
of p2pinfo since there's no check on the upper bound of noa_num.
Bound noa_num against P2P_MAX_NOA_NUM.

Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/ps.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -775,6 +775,9 @@ static void rtl_p2p_noa_ie(struct ieee80
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM)
+					noa_num = P2P_MAX_NOA_NUM;
+
 			}
 			noa_index = ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
@@ -869,6 +872,9 @@ static void rtl_p2p_action_ie(struct iee
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM)
+					noa_num = P2P_MAX_NOA_NUM;
+
 			}
 			noa_index = ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==


