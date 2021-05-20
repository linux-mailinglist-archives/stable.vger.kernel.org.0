Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAE138A5E0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbhETKVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235392AbhETKTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231066101D;
        Thu, 20 May 2021 09:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504018;
        bh=+4tdMe23bQuqQUP4daVUklvY+rrCybMlF0Fn5hePeO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQyd7w78QMTO15N9OHZhmbM21ga4pSPxiACWZf1D6Is0M1ZARTSzPaX2tNr3qAhr4
         3znqs6Z3Nv9+KBL14Rk/JxB3pbkLaOJp0PYbRNBNmzmPErCv5Og+//So5pSpVkt1mB
         Uvd81BBeHpBz0E4tuZkJE6wYXBoV+BN0mdg26B3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 023/323] mmc: block: Update ext_csd.cache_ctrl if it was written
Date:   Thu, 20 May 2021 11:18:35 +0200
Message-Id: <20210520092120.909313339@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avri Altman <avri.altman@wdc.com>

commit aea0440ad023ab0662299326f941214b0d7480bd upstream.

The cache function can be turned ON and OFF by writing to the CACHE_CTRL
byte (EXT_CSD byte [33]).  However,  card->ext_csd.cache_ctrl is only
set on init if cache size > 0.

Fix that by explicitly setting ext_csd.cache_ctrl on ext-csd write.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210420134641.57343-3-avri.altman@wdc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -599,6 +599,18 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	}
 
 	/*
+	 * Make sure to update CACHE_CTRL in case it was changed. The cache
+	 * will get turned back on if the card is re-initialized, e.g.
+	 * suspend/resume or hw reset in recovery.
+	 */
+	if ((MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) == EXT_CSD_CACHE_CTRL) &&
+	    (cmd.opcode == MMC_SWITCH)) {
+		u8 value = MMC_EXTRACT_VALUE_FROM_ARG(cmd.arg) & 1;
+
+		card->ext_csd.cache_ctrl = value;
+	}
+
+	/*
 	 * According to the SD specs, some commands require a delay after
 	 * issuing the command.
 	 */


