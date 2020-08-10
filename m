Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F8240A7C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHJPTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHJPTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:19:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8575A20772;
        Mon, 10 Aug 2020 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072777;
        bh=hBv+4okY+0hf3Z7WylDYYaK3Po0ZNDGgpxry0OId4UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjUQEE1SjwIITVslg6noLCoH2dGTAVVvGgCV3Zm5/DZwJE8RtT4vDX1a5aKiQeKVX
         2nqQJQER4flU8dUCRKOiNqbBimDDV0uE/BJhFeohk/gHFilPbatoappQHLczVnfOEk
         PpS16H0CzBmdJx4ht7mlZkY38HzaOYMiPswIm5z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>
Subject: [PATCH 5.8 14/38] Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode
Date:   Mon, 10 Aug 2020 17:19:04 +0200
Message-Id: <20200810151804.596082919@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 11536442a3b4e1de6890ea5e805908debb74f94a upstream.

The variable authmode can be uninitialized. The danger would be if
it equals to _WPA_IE_ID_ (0xdd) or _WPA2_IE_ID_ (0x33). We can avoid
this by setting it to zero instead. This is the approach that was
used in the rtl8723bs driver.

Fixes: 7b464c9fa5cc ("staging: r8188eu: Add files for new driver - part 4")
Co-developed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200728072153.9202-1-dinghao.liu@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/core/rtw_mlme.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1729,9 +1729,11 @@ int rtw_restruct_sec_ie(struct adapter *
 	if ((ndisauthmode == Ndis802_11AuthModeWPA) ||
 	    (ndisauthmode == Ndis802_11AuthModeWPAPSK))
 		authmode = _WPA_IE_ID_;
-	if ((ndisauthmode == Ndis802_11AuthModeWPA2) ||
+	else if ((ndisauthmode == Ndis802_11AuthModeWPA2) ||
 	    (ndisauthmode == Ndis802_11AuthModeWPA2PSK))
 		authmode = _WPA2_IE_ID_;
+	else
+		authmode = 0x0;
 
 	if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS)) {
 		memcpy(out_ie + ielength, psecuritypriv->wps_ie, psecuritypriv->wps_ie_len);


