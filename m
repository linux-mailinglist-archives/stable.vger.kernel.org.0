Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6B33B895
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhCOOD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233033AbhCOOAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FE9A64F0B;
        Mon, 15 Mar 2021 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816814;
        bh=rmXW1BrrexEFnDJF9MaWbYvftiMtUytwwrL7bvFJhVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rN9X7eB/8GgzBFeb/fadNqjkgky3S9uCojEW9ttJ4v/Fj6uJ3+AbRK++7jTIraNH7
         6JcqyP2cnk5FRhWjUbyDMnr7FEbDlc1Iq5qd6+nsI4Brvqx882aYzajKlWEbYzUyHQ
         VZQFuso2SicdpHh13x5gjA9EMlxfk5DfU5yMeFNk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.4 127/168] staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()
Date:   Mon, 15 Mar 2021 14:55:59 +0100
Message-Id: <20210315135554.522930342@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 87107518d7a93fec6cdb2559588862afeee800fb upstream.

We need to cap len at IW_ESSID_MAX_SIZE (32) to avoid memory corruption.
This can be controlled by the user via the ioctl.

Fixes: 5f53d8ca3d5d ("Staging: add rtl8192SU wireless usb driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YEHoAWMOSZBUw91F@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192u/r8192U_wx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -333,8 +333,10 @@ static int r8192_wx_set_scan(struct net_
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
 
 		if (req->essid_len) {
-			ieee->current_network.ssid_len = req->essid_len;
-			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
+			int len = min_t(int, req->essid_len, IW_ESSID_MAX_SIZE);
+
+			ieee->current_network.ssid_len = len;
+			memcpy(ieee->current_network.ssid, req->essid, len);
 		}
 	}
 


