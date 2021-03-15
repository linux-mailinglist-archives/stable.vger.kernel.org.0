Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E462133B8A0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhCOOEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhCOOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACA2664F5E;
        Mon, 15 Mar 2021 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816821;
        bh=Cm/Nn7sjPvLLKzeR3Jxp5wSWHSo4ZMfsZNjZY6+goL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNqa8KlR5x9m4Rn9Efrkk+8g7UkjHUveFq67Lz1xs8gBy/O1kuywdqy2LvcuV+Gl4
         PtAx5P7zfAU6yw0EHgNGMNXtPtUk8L314ZscRk6fP3b/k11RrHs1+q6iYD9XJnYpE4
         VP/h4csxeM49LFV1fLnl0VG/kVotoYeNAuwfuxzo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.19 090/120] staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()
Date:   Mon, 15 Mar 2021 14:57:21 +0100
Message-Id: <20210315135722.923359350@linuxfoundation.org>
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

commit 74b6b20df8cfe90ada777d621b54c32e69e27cd7 upstream.

This code has a check to prevent read overflow but it needs another
check to prevent writing beyond the end of the ->ssid[] array.

Fixes: a2c60d42d97c ("staging: r8188eu: Add files for new driver - part 16")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YEHymwsnHewzoam7@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1161,9 +1161,11 @@ static int rtw_wx_set_scan(struct net_de
 						break;
 					}
 					sec_len = *(pos++); len -= 1;
-					if (sec_len > 0 && sec_len <= len) {
+					if (sec_len > 0 &&
+					    sec_len <= len &&
+					    sec_len <= 32) {
 						ssid[ssid_index].SsidLength = sec_len;
-						memcpy(ssid[ssid_index].Ssid, pos, ssid[ssid_index].SsidLength);
+						memcpy(ssid[ssid_index].Ssid, pos, sec_len);
 						ssid_index++;
 					}
 					pos += sec_len;


