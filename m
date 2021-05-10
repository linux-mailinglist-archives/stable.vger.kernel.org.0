Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AC237836E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhEJKpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhEJKmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 094ED61927;
        Mon, 10 May 2021 10:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642744;
        bh=NP0EJ8kuHK4TxSdYpQDX7lgasfB84oNqD23GsylnWUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTi3J0IIGhutsRRZi9qEwEkFvrQI/ofdu6X64XeXcoE8CW8RJ4KC5+slEQfvNBYZ3
         Wl4IzTxHyruU+mnO+OZhTE5ZTi8ZEtt1KDV33mkLSmaTe8bY9AwkrwNDodR+hK+LZl
         iLT7JlOo/JsHuKUGD9JOOy8bu1O40fp+0iQTRXmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 033/299] mmc: block: Update ext_csd.cache_ctrl if it was written
Date:   Mon, 10 May 2021 12:17:10 +0200
Message-Id: <20210510102005.943751361@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
@@ -572,6 +572,18 @@ static int __mmc_blk_ioctl_cmd(struct mm
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


