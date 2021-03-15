Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B75833B8A8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhCOOEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233089AbhCOOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CF6B64F05;
        Mon, 15 Mar 2021 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816824;
        bh=IJILXJ/lhva1CVUuh0ztC/78LgrZs7xs5AEiyjmg0do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tel/cYOzvAghJCTpOwSl+psjYxKtMG0uKmzE80Ir65h4gNfYq5sVD9crG2UjT2tO8
         Z2ssgODv0MsNTkem9lG5AbONPwpsyXEU3ywrb54oaJgzBGI112JAHCV587g8/2em9B
         VL/tnZ/EwPWjK412izn3wm/TCWmGa4FszbI9PLPU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.19 092/120] staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()
Date:   Mon, 15 Mar 2021 14:57:23 +0100
Message-Id: <20210315135722.989691938@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d4ac640322b06095128a5c45ba4a1e80929fe7f3 upstream.

The "ie_len" is a value in the 1-255 range that comes from the user.  We
have to cap it to ensure that it's not too large or it could lead to
memory corruption.

Fixes: 9a7fe54ddc3a ("staging: r8188eu: Add source files for new driver - part 1")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YEHyQCrFZKTXyT7J@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -794,6 +794,7 @@ int rtw_check_beacon_data(struct adapter
 	/* SSID */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _SSID_IE_, &ie_len, (pbss_network->ie_length - _BEACON_IE_OFFSET_));
 	if (p && ie_len > 0) {
+		ie_len = min_t(int, ie_len, sizeof(pbss_network->Ssid.Ssid));
 		memset(&pbss_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
 		memcpy(pbss_network->Ssid.Ssid, (p + 2), ie_len);
 		pbss_network->Ssid.SsidLength = ie_len;
@@ -812,6 +813,7 @@ int rtw_check_beacon_data(struct adapter
 	/*  get supported rates */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _SUPPORTEDRATES_IE_, &ie_len, (pbss_network->ie_length - _BEACON_IE_OFFSET_));
 	if (p) {
+		ie_len = min_t(int, ie_len, NDIS_802_11_LENGTH_RATES_EX);
 		memcpy(supportRate, p + 2, ie_len);
 		supportRateNum = ie_len;
 	}
@@ -819,6 +821,8 @@ int rtw_check_beacon_data(struct adapter
 	/* get ext_supported rates */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _EXT_SUPPORTEDRATES_IE_, &ie_len, pbss_network->ie_length - _BEACON_IE_OFFSET_);
 	if (p) {
+		ie_len = min_t(int, ie_len,
+			       NDIS_802_11_LENGTH_RATES_EX - supportRateNum);
 		memcpy(supportRate + supportRateNum, p + 2, ie_len);
 		supportRateNum += ie_len;
 	}
@@ -932,6 +936,7 @@ int rtw_check_beacon_data(struct adapter
 
 		pht_cap->mcs.rx_mask[0] = 0xff;
 		pht_cap->mcs.rx_mask[1] = 0x0;
+		ie_len = min_t(int, ie_len, sizeof(pmlmepriv->htpriv.ht_cap));
 		memcpy(&pmlmepriv->htpriv.ht_cap, p+2, ie_len);
 	}
 


