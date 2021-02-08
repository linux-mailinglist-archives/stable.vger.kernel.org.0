Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DA7313741
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhBHPW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233512AbhBHPOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:14:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DF3064E50;
        Mon,  8 Feb 2021 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797055;
        bh=AFF/PXZT9j9GHOqC0+qWXIv9B1RA08FedsN6s7hczMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nreZYoVyTx4S05UhBkD6Km3mSpn4LwV6io25d0ZAatuFfIWVplTgWItkwpnPjMCKy
         DWh87OA1A3hah1A/yUA7S2yxfGyavZib22wnmXl7wERjzhV9UwzTjhRn82TxoyeIkA
         7CBLHVOSvExI2b9Kx2o0DAKqpiUln2jM4rL/6jh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fengnan Chang <fengnanchang@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 42/65] mmc: core: Limit retries when analyse of SDIO tuples fails
Date:   Mon,  8 Feb 2021 16:01:14 +0100
Message-Id: <20210208145811.843817731@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fengnan Chang <fengnanchang@gmail.com>

commit f92e04f764b86e55e522988e6f4b6082d19a2721 upstream.

When analysing tuples fails we may loop indefinitely to retry. Let's avoid
this by using a 10s timeout and bail if not completed earlier.

Signed-off-by: Fengnan Chang <fengnanchang@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210123033230.36442-1-fengnanchang@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio_cis.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -20,6 +20,8 @@
 #include "sdio_cis.h"
 #include "sdio_ops.h"
 
+#define SDIO_READ_CIS_TIMEOUT_MS  (10 * 1000) /* 10s */
+
 static int cistpl_vers_1(struct mmc_card *card, struct sdio_func *func,
 			 const unsigned char *buf, unsigned size)
 {
@@ -266,6 +268,8 @@ static int sdio_read_cis(struct mmc_card
 
 	do {
 		unsigned char tpl_code, tpl_link;
+		unsigned long timeout = jiffies +
+			msecs_to_jiffies(SDIO_READ_CIS_TIMEOUT_MS);
 
 		ret = mmc_io_rw_direct(card, 0, 0, ptr++, 0, &tpl_code);
 		if (ret)
@@ -318,6 +322,8 @@ static int sdio_read_cis(struct mmc_card
 			prev = &this->next;
 
 			if (ret == -ENOENT) {
+				if (time_after(jiffies, timeout))
+					break;
 				/* warn about unknown tuples */
 				pr_warn_ratelimited("%s: queuing unknown"
 				       " CIS tuple 0x%02x (%u bytes)\n",


