Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DC8171EF1
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387466AbgB0ODp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:03:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387463AbgB0ODo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:03:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830AE24691;
        Thu, 27 Feb 2020 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812224;
        bh=YoImnijzEvH+A8LvlTxzAcelxjt7YPf0k7Fc6BGfJag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkJkxj4UbYB3GeZFlceG3I0IeMBubl0hoX4TTBUAYEDRz6Cnhyg68TC7cJE4yJ/sC
         JRSC7lenf2gG8LBMRykUXpX24wcnDH6PRksKQ4rwbmQn/gZz2cCvpFHhg+xjVXps+Y
         psaIhD/52qljZIoUrTfk+zAF8J+w7/fWzWaMhsp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pietro Oliva <pietroliva@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4.19 33/97] staging: rtl8723bs: Fix potential security hole
Date:   Thu, 27 Feb 2020 14:36:41 +0100
Message-Id: <20200227132220.020655108@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit ac33597c0c0d1d819dccfe001bcd0acef7107e7c upstream.

In routine rtw_hostapd_ioctl(), the user-controlled p->length is assumed
to be at least the size of struct ieee_param size, but this assumption is
never checked. This could result in out-of-bounds read/write on kernel
heap in case a p->length less than the size of struct ieee_param is
specified by the user. If p->length is allowed to be greater than the size
of the struct, then a malicious user could be wasting kernel memory.
Fixes commit 554c0a3abf216 ("0taging: Add rtl8723bs sdio wifi driver").

Reported by: Pietro Oliva <pietroliva@gmail.com>
Cc: Pietro Oliva <pietroliva@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Fixes 554c0a3abf216 ("0taging: Add rtl8723bs sdio wifi driver").
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/r/20200210180235.21691-3-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -4236,7 +4236,7 @@ static int rtw_hostapd_ioctl(struct net_
 
 
 	/* if (p->length < sizeof(struct ieee_param) || !p->pointer) { */
-	if (!p->pointer) {
+	if (!p->pointer || p->length != sizeof(*param)) {
 		ret = -EINVAL;
 		goto out;
 	}


