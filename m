Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1852409F5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgHJP00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgHJP0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D8B20772;
        Mon, 10 Aug 2020 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073183;
        bh=srrFngW9COZ0NBOZJ12ulz2veNOxnhxSRLVj9eaA6Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9vqoCdIqg7VkhBzyPYVvw81QR31yrE99ta1K4z1jhHB3eFq4ljWlRsaj+C5HeIX1
         oaiFBbwHHqyt8CvU9BAqZD7v27N8swNhM8zdbClvjY/N007OBbOiZ1nrqYIPtyhuer
         029d2nGrK85ZZsu5zCLnChVzMbyf2nRCzWTqRQDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>
Subject: [PATCH 5.4 16/67] Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode
Date:   Mon, 10 Aug 2020 17:21:03 +0200
Message-Id: <20200810151810.227925994@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
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
 		memcpy(out_ie+ielength, psecuritypriv->wps_ie, psecuritypriv->wps_ie_len);


