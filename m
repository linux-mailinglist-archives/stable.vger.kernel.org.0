Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9093136D5
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhBHPQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:16:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231898AbhBHPLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:11:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2703464EDA;
        Mon,  8 Feb 2021 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796886;
        bh=V2BQ8FzKKKz/+Gj8xT4s0dh8W02fkI2A8nuo7hZcPmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiyXnyN1c/m2fCVrfV+AfQhoml+H643lN6n/430JtRdbWAXocjQCSCPOrEi5ydw6U
         cW3o4ueygoKOMHnUkaXd7iXkIokqTWyGyiBTmuoTkG9j0TK1UIYnXf83SkPa+iK+Vg
         eFGDQUdlCevZvRDfgi6IvGku2J/YtbwPGkIQMAes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fengnan Chang <fengnanchang@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 23/38] mmc: core: Limit retries when analyse of SDIO tuples fails
Date:   Mon,  8 Feb 2021 16:01:10 +0100
Message-Id: <20210208145807.091038265@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
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
@@ -270,6 +272,8 @@ static int sdio_read_cis(struct mmc_card
 
 	do {
 		unsigned char tpl_code, tpl_link;
+		unsigned long timeout = jiffies +
+			msecs_to_jiffies(SDIO_READ_CIS_TIMEOUT_MS);
 
 		ret = mmc_io_rw_direct(card, 0, 0, ptr++, 0, &tpl_code);
 		if (ret)
@@ -322,6 +326,8 @@ static int sdio_read_cis(struct mmc_card
 			prev = &this->next;
 
 			if (ret == -ENOENT) {
+				if (time_after(jiffies, timeout))
+					break;
 				/* warn about unknown tuples */
 				pr_warn_ratelimited("%s: queuing unknown"
 				       " CIS tuple 0x%02x (%u bytes)\n",


