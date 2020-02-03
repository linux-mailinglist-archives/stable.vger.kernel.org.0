Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71453150E1D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgBCQtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgBCQZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:07 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9982087E;
        Mon,  3 Feb 2020 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747107;
        bh=0g42LAuj0tkgZiv0m+pSxZl1NoIyGCndGzp3CHEoVCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQWGeA5UBnWrqdPRXDc2GRmBcQQbi08WgiDnl16dNTBKJb7fzDG/CEB5yyvPL5hH9
         OOa6/WGVeCxAFgw85szYf4k+GJBmaJ3Yd2SLiX+eAF2sH75l4psMcSCntCzfKlKoOB
         iu7sZdjXbgFSTVeacZBJhzqEwBsAFaB5dXaZHqkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 15/68] rtl8xxxu: fix interface sanity check
Date:   Mon,  3 Feb 2020 16:19:11 +0000
Message-Id: <20200203161907.505766838@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 39a4281c312f2d226c710bc656ce380c621a2b16 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Cc: stable <stable@vger.kernel.org>     # 4.4
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5890,7 +5890,7 @@ static int rtl8xxxu_parse_usb(struct rtl
 	u8 dir, xtype, num;
 	int ret = 0;
 
-	host_interface = &interface->altsetting[0];
+	host_interface = interface->cur_altsetting;
 	interface_desc = &host_interface->desc;
 	endpoints = interface_desc->bNumEndpoints;
 


