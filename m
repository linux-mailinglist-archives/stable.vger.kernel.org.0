Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FF733B8DB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhCOOEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhCOOAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A6D64EF1;
        Mon, 15 Mar 2021 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816797;
        bh=8h5kP37kz3qttrvG3J9fWkt05nE7wWqaiFUVhbTE3bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjpVhX9Rt66mB7rkt9vgAcH+2UgsFMBNP4tvVn5bSRBMCuQIC5Lxg4CatkOCMaAlz
         SjXzwWWVPhm2ZwLdYbVZsx9Q+bSBCjE0uwFxHUH3mmTaMbYQvNjQAuTCvN3I25PmcT
         Um5aYIbpJQN2S0MTgNzuxGOjVJV+rHTx664ymPuU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.14 69/95] staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()
Date:   Mon, 15 Mar 2021 14:57:39 +0100
Message-Id: <20210315135742.531725456@linuxfoundation.org>
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

commit e163b9823a0b08c3bb8dc4f5b4b5c221c24ec3e5 upstream.

The user can specify a "req->essid_len" of up to 255 but if it's
over IW_ESSID_MAX_SIZE (32) that can lead to memory corruption.

Fixes: 13a9930d15b4 ("staging: ks7010: add driver from Nanonote extra-repository")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YD4fS8+HmM/Qmrw6@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/ks7010/ks_wlan_net.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/ks7010/ks_wlan_net.c
+++ b/drivers/staging/ks7010/ks_wlan_net.c
@@ -1290,6 +1290,7 @@ static int ks_wlan_set_scan(struct net_d
 {
 	struct ks_wlan_private *priv = netdev_priv(dev);
 	struct iw_scan_req *req = NULL;
+	int len;
 
 	DPRINTK(2, "\n");
 
@@ -1301,8 +1302,9 @@ static int ks_wlan_set_scan(struct net_d
 	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
 	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		req = (struct iw_scan_req *)extra;
-		priv->scan_ssid_len = req->essid_len;
-		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
+		len = min_t(int, req->essid_len, IW_ESSID_MAX_SIZE);
+		priv->scan_ssid_len = len;
+		memcpy(priv->scan_ssid, req->essid, len);
 	} else {
 		priv->scan_ssid_len = 0;
 	}


