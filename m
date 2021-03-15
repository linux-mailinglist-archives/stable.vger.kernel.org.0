Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D9633B9B5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhCOOGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233470AbhCOOBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC13F64E89;
        Mon, 15 Mar 2021 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816900;
        bh=PTIV3Q+ldmGS5yR7bJr3pPecoqqWfaeNBLeyEKfVCc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LMJCaxfzuZHZOsyrMQmSeYAbfxpUQAs4+ttHGLHYs6NXeYbtddfA7VD6Km6gB7JU
         lrT60E5XIJLMEAPrVlHXzqdFnz19SuYQ0wDctJ0iL28iylCq5tTeFMaH4tLXUsZ+Wu
         hb4BKxaQKFPv6nyXH/6W2AYHXKoPli4fG3dFHVyo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.11 190/306] mmc: core: Fix partition switch time for eMMC
Date:   Mon, 15 Mar 2021 14:54:13 +0100
Message-Id: <20210315135514.031728471@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Adrian Hunter <adrian.hunter@intel.com>

commit 66fbacccbab91e6e55d9c8f1fc0910a8eb6c81f7 upstream.

Avoid the following warning by always defining partition switch time:

 [    3.209874] mmc1: unspecified timeout for CMD6 - use generic
 [    3.222780] ------------[ cut here ]------------
 [    3.233363] WARNING: CPU: 1 PID: 111 at drivers/mmc/core/mmc_ops.c:575 __mmc_switch+0x200/0x204

Reported-by: Paul Fertser <fercerpav@gmail.com>
Fixes: 1c447116d017 ("mmc: mmc: Fix partition switch timeout for some eMMCs")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/168bbfd6-0c5b-5ace-ab41-402e7937c46e@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -423,10 +423,6 @@ static int mmc_decode_ext_csd(struct mmc
 
 		/* EXT_CSD value is in units of 10ms, but we store in ms */
 		card->ext_csd.part_time = 10 * ext_csd[EXT_CSD_PART_SWITCH_TIME];
-		/* Some eMMC set the value too low so set a minimum */
-		if (card->ext_csd.part_time &&
-		    card->ext_csd.part_time < MMC_MIN_PART_SWITCH_TIME)
-			card->ext_csd.part_time = MMC_MIN_PART_SWITCH_TIME;
 
 		/* Sleep / awake timeout in 100ns units */
 		if (sa_shift > 0 && sa_shift <= 0x17)
@@ -616,6 +612,17 @@ static int mmc_decode_ext_csd(struct mmc
 		card->ext_csd.data_sector_size = 512;
 	}
 
+	/*
+	 * GENERIC_CMD6_TIME is to be used "unless a specific timeout is defined
+	 * when accessing a specific field", so use it here if there is no
+	 * PARTITION_SWITCH_TIME.
+	 */
+	if (!card->ext_csd.part_time)
+		card->ext_csd.part_time = card->ext_csd.generic_cmd6_time;
+	/* Some eMMC set the value too low so set a minimum */
+	if (card->ext_csd.part_time < MMC_MIN_PART_SWITCH_TIME)
+		card->ext_csd.part_time = MMC_MIN_PART_SWITCH_TIME;
+
 	/* eMMC v5 or later */
 	if (card->ext_csd.rev >= 7) {
 		memcpy(card->ext_csd.fwrev, &ext_csd[EXT_CSD_FIRMWARE_VERSION],


