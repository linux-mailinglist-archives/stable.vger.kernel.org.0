Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5226B6C762
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389247AbfGRDXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390574AbfGRDIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:00 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63C72173B;
        Thu, 18 Jul 2019 03:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419279;
        bh=p7qARXKPniQ4Gp1UilfQNwHUhNLhD7ZHzbN/ZdiWL40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUyH5L/K6hgDi5fEs1k1+7HYwbr/yTnccLyHsqy1cjH/fY+Xr2s4BdYo8fncUhtA4
         8ni7I80X62MtWub5mO99PLNp/1wjisNhmjIbhi0jQu0TfYdGr1B5gPp0qjIkX5PZ87
         hRts4jzo60VMosB7rBS6WqCHkSqN2Li2uEzVFE10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haren Myneni <haren@us.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 42/47] crypto/NX: Set receive window credits to max number of CRBs in RxFIFO
Date:   Thu, 18 Jul 2019 12:01:56 +0900
Message-Id: <20190718030052.300915199@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haren Myneni <haren@linux.vnet.ibm.com>

commit e52d484d9869eb291140545746ccbe5ffc7c9306 upstream.

System gets checkstop if RxFIFO overruns with more requests than the
maximum possible number of CRBs in FIFO at the same time. The max number
of requests per window is controlled by window credits. So find max
CRBs from FIFO size and set it to receive window credits.

Fixes: b0d6c9bab5e4 ("crypto/nx: Add P9 NX support for 842 compression engine")
CC: stable@vger.kernel.org # v4.14+
Signed-off-by:Haren Myneni <haren@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

---
 drivers/crypto/nx/nx-842-powernv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -36,8 +36,6 @@ MODULE_ALIAS_CRYPTO("842-nx");
 #define WORKMEM_ALIGN	(CRB_ALIGN)
 #define CSB_WAIT_MAX	(5000) /* ms */
 #define VAS_RETRIES	(10)
-/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
-#define MAX_CREDITS_PER_RXFIFO	(1024)
 
 struct nx842_workmem {
 	/* Below fields must be properly aligned */
@@ -821,7 +819,11 @@ static int __init vas_cfg_coproc_info(st
 	rxattr.lnotify_lpid = lpid;
 	rxattr.lnotify_pid = pid;
 	rxattr.lnotify_tid = tid;
-	rxattr.wcreds_max = MAX_CREDITS_PER_RXFIFO;
+	/*
+	 * Maximum RX window credits can not be more than #CRBs in
+	 * RxFIFO. Otherwise, can get checkstop if RxFIFO overruns.
+	 */
+	rxattr.wcreds_max = fifo_size / CRB_SIZE;
 
 	/*
 	 * Open a VAS receice window which is used to configure RxFIFO


