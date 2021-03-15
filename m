Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273A433B591
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhCONyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231213AbhCONyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ED1D601FD;
        Mon, 15 Mar 2021 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816454;
        bh=gBLWqRKW6uXW1BdmXR1ZQ+oprUn9KRBhm8RRwiFkKAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjDZkygcJPwiwJJhAME29jK9YAybJNH28/jA2DRHRFDpisDHH1i/gqOhl7OOY1G2l
         sd2lMgHJwT5EC6/UOY/zs6DI8eY4VnbZ7GAcbfib4AWQ0X02EuSZIeNfWLPe3YQNut
         4eQoeSZp0lgMET28fMGaFpINVSF9duNRdW5S2Xis=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.9 48/78] staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()
Date:   Mon, 15 Mar 2021 14:52:11 +0100
Message-Id: <20210315135213.644225264@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
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
@@ -1404,6 +1404,7 @@ static int ks_wlan_set_scan(struct net_d
 	struct ks_wlan_private *priv =
 	    (struct ks_wlan_private *)netdev_priv(dev);
 	struct iw_scan_req *req = NULL;
+	int len;
 	DPRINTK(2, "\n");
 
 	if (priv->sleep_mode == SLP_SLEEP) {
@@ -1415,8 +1416,9 @@ static int ks_wlan_set_scan(struct net_d
 	if (wrqu->data.length == sizeof(struct iw_scan_req)
 	    && wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		req = (struct iw_scan_req *)extra;
-		priv->scan_ssid_len = req->essid_len;
-		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
+		len = min_t(int, req->essid_len, IW_ESSID_MAX_SIZE);
+		priv->scan_ssid_len = len;
+		memcpy(priv->scan_ssid, req->essid, len);
 	} else {
 		priv->scan_ssid_len = 0;
 	}


