Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2903D2F1D1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfE3EQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbfE3DPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:52 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E0A924580;
        Thu, 30 May 2019 03:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186152;
        bh=bl2tX/LPrbTjmBMGofl2C4e06mLz01hY1QeO3K0QEN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyAdrn30TQnFmbyAQxFAUR+Hxq0A3okBQKxjuCiFykEixVu/VLW5aomenwh7REtXs
         AbLTX3S9Z652T6P3jC4HLyRH9OlB0jgELof5EidcSmmrQTwFKbiHjaysq7HpRVJHaV
         efM9VMVgyZwYV/tJBlg1WYZUM9yuE60m35wCKa5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lesiak <chris.lesiak@licor.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 336/346] spi: Fix zero length xfer bug
Date:   Wed, 29 May 2019 20:06:49 -0700
Message-Id: <20190530030557.766686934@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5442dcaa0d90fc376bdfc179a018931a8f43dea4 ]

This fixes a bug for messages containing both zero length and
unidirectional xfers.

The function spi_map_msg will allocate dummy tx and/or rx buffers
for use with unidirectional transfers when the hardware can only do
a bidirectional transfer.  That dummy buffer will be used in place
of a NULL buffer even when the xfer length is 0.

Then in the function __spi_map_msg, if he hardware can dma,
the zero length xfer will have spi_map_buf called on the dummy
buffer.

Eventually, __sg_alloc_table is called and returns -EINVAL
because nents == 0.

This fix prevents the error by not using the dummy buffer when
the xfer length is zero.

Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 9a7def7c32370..0632a32c11055 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1024,6 +1024,8 @@ static int spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 		if (max_tx || max_rx) {
 			list_for_each_entry(xfer, &msg->transfers,
 					    transfer_list) {
+				if (!xfer->len)
+					continue;
 				if (!xfer->tx_buf)
 					xfer->tx_buf = ctlr->dummy_tx;
 				if (!xfer->rx_buf)
-- 
2.20.1



