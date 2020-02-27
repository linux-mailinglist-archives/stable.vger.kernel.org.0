Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76E171F3F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbgB0OAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732702AbgB0OAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:00:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B2420578;
        Thu, 27 Feb 2020 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812018;
        bh=tqXNySAPNmZuyfwbHmmxm2ECeTdG1X/DKP6NQ6yJImI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mozcLVdGZNgcpPCfjCz78+9SiBTJ8QcFjSQ5Q5XWusyFxbFpqtFg7Er4rSB/MLE4S
         E71n5f28s79SQ7c9MHj+SBwFa6aVHVD+6q5YRiMnnTNvO5pY5vRfqMzxR9pJLJNRbX
         iG518DHLYyV60DtnGn8X5aFRFBiGmBNHjWiDTsyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pietro Oliva <pietroliva@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4.14 189/237] staging: rtl8723bs: Fix potential security hole
Date:   Thu, 27 Feb 2020 14:36:43 +0100
Message-Id: <20200227132310.232973405@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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
@@ -4340,7 +4340,7 @@ static int rtw_hostapd_ioctl(struct net_
 
 
 	/* if (p->length < sizeof(struct ieee_param) || !p->pointer) { */
-	if (!p->pointer) {
+	if (!p->pointer || p->length != sizeof(*param)) {
 		ret = -EINVAL;
 		goto out;
 	}


