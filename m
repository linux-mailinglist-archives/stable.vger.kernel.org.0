Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DAE33BA48
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhCOOIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234198AbhCOODD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C9C64EEE;
        Mon, 15 Mar 2021 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816982;
        bh=y936yeVlW7Axkpod6hrD2yfHxzmIRGBM0q+s8LL4oas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4DSw0WcDbhJuDWobkN80p5dXaGqCAIASFC4OBoXmAynN8OXGcDuo460j5+7e/zmH
         opIU+BpR24AP9LjXOp1LG7VN7hcvcsH1QtU3Czg02wUJFpFzo14XQQXrDfZj/Geb3m
         1oh0rMR94TCgGkSXrqAZp0qieZGEsGwnm977L/R0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 227/290] staging: rtl8712: unterminated string leads to read overflow
Date:   Mon, 15 Mar 2021 14:55:20 +0100
Message-Id: <20210315135549.650901835@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d660f4f42ccea50262c6ee90c8e7ad19a69fb225 upstream.

The memdup_user() function does not necessarily return a NUL terminated
string so this can lead to a read overflow.  Switch from memdup_user()
to strndup_user() to fix this bug.

Fixes: c6dc001f2add ("staging: r8712u: Merging Realtek's latest (v2.6.6). Various fixes.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YDYSR+1rj26NRhvb@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -924,7 +924,7 @@ static int r871x_wx_set_priv(struct net_
 	struct iw_point *dwrq = (struct iw_point *)awrq;
 
 	len = dwrq->length;
-	ext = memdup_user(dwrq->pointer, len);
+	ext = strndup_user(dwrq->pointer, len);
 	if (IS_ERR(ext))
 		return PTR_ERR(ext);
 


