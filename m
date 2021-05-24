Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686EE38EFF0
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhEXQA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234086AbhEXP7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1D761977;
        Mon, 24 May 2021 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871128;
        bh=ixhFpQz0nlCLsTx+AGp7ZLRmJh2P0VlBJgxy83FfUmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/f8wWn8P4/UEkgDd19ivg9+KKbBx67TOqsYPbX8i4jYgEMgt0ZzZMdIoX1PdOEX0
         Tl8MdCer+7Kxr2CoujD2/YmpNw0Iq/6E3Qbap54Db8RfT2euUqljE0tykvvEo5/Z8g
         L/dSANEgwKmlTjwdB0P61yS/Arxn72trxjWwku7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.12 086/127] mmc: meson-gx: also check SD_IO_RW_EXTENDED for scatterlist size alignment
Date:   Mon, 24 May 2021 17:26:43 +0200
Message-Id: <20210524152337.767670885@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 9b81354d7ebc1fd17f666a168dcabf27dae290bd upstream.

The brcmfmac driver can generate a scatterlist from a skb with each packets
not aligned to the block size. This is not supported by the Amlogic Descriptor
dma engine where each descriptor must match a multiple of the block size.

The sg list is valid, since the sum of the sg buffers is a multiple of the
block size, but we must discard those when in SD_IO_RW_EXTENDED mode since
SDIO block mode can be used under the hood even with data->blocks == 1.

Those transfers are very rare, thus can be replaced by a bounce buffer
without real performance loss.

Fixes: 7412dee9f1fd ("mmc: meson-gx: replace WARN_ONCE with dev_warn_once about scatterlist size alignment in block mode")
Cc: stable@vger.kernel.org
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210426175559.3110575-2-narmstrong@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -236,7 +236,8 @@ static void meson_mmc_get_transfer_mode(
 	if (host->dram_access_quirk)
 		return;
 
-	if (data->blocks > 1) {
+	/* SD_IO_RW_EXTENDED (CMD53) can also use block mode under the hood */
+	if (data->blocks > 1 || mrq->cmd->opcode == SD_IO_RW_EXTENDED) {
 		/*
 		 * In block mode DMA descriptor format, "length" field indicates
 		 * number of blocks and there is no way to pass DMA size that


