Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7029533B82A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhCOOCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232921AbhCOOAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF36B64F3A;
        Mon, 15 Mar 2021 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816796;
        bh=x1wAsW9tB4M9KVSt7+cvA1n8HyZAjvcsT5J/9KcaGfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1jjLyAn+RVsFZ94Epm6yb5gCG60mQNPh12gOtFPhkxbFnFFr7oz8NJIyN5gDNJV4
         s7qHQ91zKlauHsUAllByoPsLk0AS6Kd0qvl8AyNMhxq/UcIGS3YQ1zLs4GJAVKYBM/
         owaoXgi4/VQgzpxsCN7E9VzTmXoEo3DXKWAsfQjI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.14 68/95] staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()
Date:   Mon, 15 Mar 2021 14:57:38 +0100
Message-Id: <20210315135742.496667250@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
@@ -912,6 +912,7 @@ int rtw_check_beacon_data(struct adapter
 	/* SSID */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _SSID_IE_, &ie_len, (pbss_network->IELength - _BEACON_IE_OFFSET_));
 	if (p && ie_len > 0) {
+		ie_len = min_t(int, ie_len, sizeof(pbss_network->Ssid.Ssid));
 		memset(&pbss_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
 		memcpy(pbss_network->Ssid.Ssid, (p + 2), ie_len);
 		pbss_network->Ssid.SsidLength = ie_len;
@@ -930,6 +931,7 @@ int rtw_check_beacon_data(struct adapter
 	/*  get supported rates */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _SUPPORTEDRATES_IE_, &ie_len, (pbss_network->IELength - _BEACON_IE_OFFSET_));
 	if (p) {
+		ie_len = min_t(int, ie_len, NDIS_802_11_LENGTH_RATES_EX);
 		memcpy(supportRate, p + 2, ie_len);
 		supportRateNum = ie_len;
 	}
@@ -937,6 +939,8 @@ int rtw_check_beacon_data(struct adapter
 	/* get ext_supported rates */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _EXT_SUPPORTEDRATES_IE_, &ie_len, pbss_network->IELength - _BEACON_IE_OFFSET_);
 	if (p) {
+		ie_len = min_t(int, ie_len,
+			       NDIS_802_11_LENGTH_RATES_EX - supportRateNum);
 		memcpy(supportRate + supportRateNum, p + 2, ie_len);
 		supportRateNum += ie_len;
 	}
@@ -1050,6 +1054,7 @@ int rtw_check_beacon_data(struct adapter
 
 		pht_cap->mcs.rx_mask[0] = 0xff;
 		pht_cap->mcs.rx_mask[1] = 0x0;
+		ie_len = min_t(int, ie_len, sizeof(pmlmepriv->htpriv.ht_cap));
 		memcpy(&pmlmepriv->htpriv.ht_cap, p+2, ie_len);
 	}
 


