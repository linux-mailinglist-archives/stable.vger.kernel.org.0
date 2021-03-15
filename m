Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F28233BA4D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhCOOIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234259AbhCOODI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 142CF64EF9;
        Mon, 15 Mar 2021 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816988;
        bh=YbbD2OM49azgxz1waoAEtRW/HfYSxogBZ1pRKo4eEYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJBQrD1r1uEqm5vPil4AU8IXP1NSxbXv0ccDl7iRxKDp2MsvqJiEQVsaykn2CtLZ2
         9H/q0E5yWaj0Oe4487YjJ/GY9XSxtYJWMqpuFzHukOU4CYXoandgGiIjV+GFRVJHtQ
         VMCgAwIFmQ3/itVaJbfwDRA4m1TJvZicL015lJ0E=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lee Gibson <leegib@gmail.com>
Subject: [PATCH 5.10 231/290] staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan
Date:   Mon, 15 Mar 2021 14:55:24 +0100
Message-Id: <20210315135549.793415394@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Lee Gibson <leegib@gmail.com>

commit 8687bf9ef9551bcf93897e33364d121667b1aadf upstream.

Function _rtl92e_wx_set_scan calls memcpy without checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Gibson <leegib@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210226145157.424065-1-leegib@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -406,9 +406,10 @@ static int _rtl92e_wx_set_scan(struct ne
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
 
 		if (req->essid_len) {
-			ieee->current_network.ssid_len = req->essid_len;
-			memcpy(ieee->current_network.ssid, req->essid,
-			       req->essid_len);
+			int len = min_t(int, req->essid_len, IW_ESSID_MAX_SIZE);
+
+			ieee->current_network.ssid_len = len;
+			memcpy(ieee->current_network.ssid, req->essid, len);
 		}
 	}
 


