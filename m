Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A783313609
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhBHPFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhBHPD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE3E64EBA;
        Mon,  8 Feb 2021 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796575;
        bh=v8111njtkhgxdRXQZg+MMAsXlsBPdA6A0HwAUrHxhHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W31gZi5pJQyD/MIxnRgWxfQ9YFF3NTY5doaMDMJLlw2fKuMagWfU0WglZXYGSwIzq
         blUMT/Ou0tv/TzoVUDs+8sSJW9lBvbSx10X7PH4ZQ4u4jQVNqdlV4m73/Es3KSbFwy
         JyOZTE7u/DAnHisNoRGDXwHpbAJZ4rwX1hkxiRdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fengnan Chang <fengnanchang@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 29/38] mmc: core: Limit retries when analyse of SDIO tuples fails
Date:   Mon,  8 Feb 2021 16:00:51 +0100
Message-Id: <20210208145806.420787766@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
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
@@ -263,6 +265,8 @@ static int sdio_read_cis(struct mmc_card
 
 	do {
 		unsigned char tpl_code, tpl_link;
+		unsigned long timeout = jiffies +
+			msecs_to_jiffies(SDIO_READ_CIS_TIMEOUT_MS);
 
 		ret = mmc_io_rw_direct(card, 0, 0, ptr++, 0, &tpl_code);
 		if (ret)
@@ -315,6 +319,8 @@ static int sdio_read_cis(struct mmc_card
 			prev = &this->next;
 
 			if (ret == -ENOENT) {
+				if (time_after(jiffies, timeout))
+					break;
 				/* warn about unknown tuples */
 				pr_warn_ratelimited("%s: queuing unknown"
 				       " CIS tuple 0x%02x (%u bytes)\n",


