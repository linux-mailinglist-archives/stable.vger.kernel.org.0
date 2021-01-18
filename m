Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122382F9E92
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390657AbhARLnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390827AbhARLnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A822221EC;
        Mon, 18 Jan 2021 11:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970196;
        bh=byiYvvTnmGUoUR8k/HrJGd3sxguP1G+iK44YQb320ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGPwsrd9fruQSP7VEpLpjHPuWOPRqPFuRdAur315ZlUJXk9dlsX7mOZQztV1QfdIr
         GRNl06iRgSwnd+w8NqPhl1p2vA8SRwnWJIV29HIbjskFaZuHw+5qRBt7qsXygsNC29
         9GNb7QNVDSYY7PbpysNBQsIhpxPAlUcmO2N8IEDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/152] spi: fix the divide by 0 error when calculating xfer waiting time
Date:   Mon, 18 Jan 2021 12:34:13 +0100
Message-Id: <20210118113356.525299149@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yilun <yilun.xu@intel.com>

[ Upstream commit 6170d077bf92c5b3dfbe1021688d3c0404f7c9e9 ]

The xfer waiting time is the result of xfer->len / xfer->speed_hz. This
patch makes the assumption of 100khz xfer speed if the xfer->speed_hz is
not assigned and stays 0. This avoids the divide by 0 issue and ensures
a reasonable tolerant waiting time.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/1609723749-3557-1-git-send-email-yilun.xu@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 2eaa7dbb70108..7694e1ae5b0b2 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1100,6 +1100,7 @@ static int spi_transfer_wait(struct spi_controller *ctlr,
 {
 	struct spi_statistics *statm = &ctlr->statistics;
 	struct spi_statistics *stats = &msg->spi->statistics;
+	u32 speed_hz = xfer->speed_hz;
 	unsigned long long ms;
 
 	if (spi_controller_is_slave(ctlr)) {
@@ -1108,8 +1109,11 @@ static int spi_transfer_wait(struct spi_controller *ctlr,
 			return -EINTR;
 		}
 	} else {
+		if (!speed_hz)
+			speed_hz = 100000;
+
 		ms = 8LL * 1000LL * xfer->len;
-		do_div(ms, xfer->speed_hz);
+		do_div(ms, speed_hz);
 		ms += ms + 200; /* some tolerance */
 
 		if (ms > UINT_MAX)
-- 
2.27.0



