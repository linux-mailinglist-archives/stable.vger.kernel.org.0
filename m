Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6694131364E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhBHPJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232690AbhBHPG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:06:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7154A64EE3;
        Mon,  8 Feb 2021 15:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796695;
        bh=bJJtpk2EAQTf2zp91XPIaJD+lqMxr/92d9ylY371Ddg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1ICX63XxzF8Sf9EBpzoi5oaMgI6TJAtZ7BIcgEBMw4WZaq2V3Iy+bRdt5W9OqywD
         Wpt0F6ExEhpo3SePYYY+KMDDmcPo/f4Uv1rlQfsIq9S2As6kS0QvGaZ1KZ4V1BhiKm
         qKWFf/+cXyIjt7xDWJsj9Y6XBx6BLCRhNXoMI8fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fengnan Chang <fengnanchang@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.9 32/43] mmc: core: Limit retries when analyse of SDIO tuples fails
Date:   Mon,  8 Feb 2021 16:00:58 +0100
Message-Id: <20210208145807.614886928@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
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
@@ -24,6 +24,8 @@
 #include "sdio_cis.h"
 #include "sdio_ops.h"
 
+#define SDIO_READ_CIS_TIMEOUT_MS  (10 * 1000) /* 10s */
+
 static int cistpl_vers_1(struct mmc_card *card, struct sdio_func *func,
 			 const unsigned char *buf, unsigned size)
 {
@@ -269,6 +271,8 @@ static int sdio_read_cis(struct mmc_card
 
 	do {
 		unsigned char tpl_code, tpl_link;
+		unsigned long timeout = jiffies +
+			msecs_to_jiffies(SDIO_READ_CIS_TIMEOUT_MS);
 
 		ret = mmc_io_rw_direct(card, 0, 0, ptr++, 0, &tpl_code);
 		if (ret)
@@ -321,6 +325,8 @@ static int sdio_read_cis(struct mmc_card
 			prev = &this->next;
 
 			if (ret == -ENOENT) {
+				if (time_after(jiffies, timeout))
+					break;
 				/* warn about unknown tuples */
 				pr_warn_ratelimited("%s: queuing unknown"
 				       " CIS tuple 0x%02x (%u bytes)\n",


