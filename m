Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D3113A677
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgANKLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732668AbgANKLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:11:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47FB124677;
        Tue, 14 Jan 2020 10:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996701;
        bh=UtpKgFdUgwj+i7ozPOAQauU/7XIGYCPBjWsPM7pu5Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUTWKrC4xhOvyjPTWzNZbYYXKSHQvHI/d1h9++2XPSyO66PJjgcAeO2HhQAvvjrPt
         GB5nTkyUox2+T/PYZRhm4tKEC27oi2xHdPGA4O4RVzgm9TX7H5e+XcnSzKDGDupuLv
         xrrolkCZppav10aFhOTLwKYxO2hDeSNdAsf02Dag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huangwen <huangwenabc@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 25/31] mwifiex: fix possible heap overflow in mwifiex_process_country_ie()
Date:   Tue, 14 Jan 2020 11:02:17 +0100
Message-Id: <20200114094344.665329691@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganapathi Bhat <gbhat@marvell.com>

commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b upstream.

mwifiex_process_country_ie() function parse elements of bss
descriptor in beacon packet. When processing WLAN_EID_COUNTRY
element, there is no upper limit check for country_ie_len before
calling memcpy. The destination buffer domain_info->triplet is an
array of length MWIFIEX_MAX_TRIPLET_802_11D(83). The remote
attacker can build a fake AP with the same ssid as real AP, and
send malicous beacon packet with long WLAN_EID_COUNTRY elemen
(country_ie_len > 83). Attacker can  force STA connect to fake AP
on a different channel. When the victim STA connects to fake AP,
will trigger the heap buffer overflow. Fix this by checking for
length and if found invalid, don not connect to the AP.

This fix addresses CVE-2019-14895.

Reported-by: huangwen <huangwenabc@gmail.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -271,6 +271,14 @@ static int mwifiex_process_country_ie(st
 			    "11D: skip setting domain info in FW\n");
 		return 0;
 	}
+
+	if (country_ie_len >
+	    (IEEE80211_COUNTRY_STRING_LEN + MWIFIEX_MAX_TRIPLET_802_11D)) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "11D: country_ie_len overflow!, deauth AP\n");
+		return -EINVAL;
+	}
+
 	memcpy(priv->adapter->country_code, &country_ie[2], 2);
 
 	domain_info->country_code[0] = country_ie[2];
@@ -314,8 +322,9 @@ int mwifiex_bss_start(struct mwifiex_pri
 	priv->scan_block = false;
 
 	if (bss) {
-		if (adapter->region_code == 0x00)
-			mwifiex_process_country_ie(priv, bss);
+		if (adapter->region_code == 0x00 &&
+		    mwifiex_process_country_ie(priv, bss))
+			return -EINVAL;
 
 		/* Allocate and fill new bss descriptor */
 		bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),


