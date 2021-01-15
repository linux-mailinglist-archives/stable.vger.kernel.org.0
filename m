Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095872F7AC5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387668AbhAOMyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387696AbhAOMfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96E6235F8;
        Fri, 15 Jan 2021 12:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714092;
        bh=gAuB4bxz3JyCVSL+w75fTiFRumZx+0gm9gjg+URFPoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQFeVstFotSFmuIeToTXThOyaQDD8qGpAs7hbJl5k9JuEMi2v14cFYr01wnbx/g6g
         6MPgfztHEXoBFFrhbupkgr2hIBTjEuWnHrpoL3pcC9IVGpZR9eXIXCgSXzrTLp2foD
         bCpRz+bpkTBtJPcsi3Ga0NeVMEIAaR8iLCtpp6pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Guskov <rguskov@dh-electronics.com>,
        Marek Vasut <marex@denx.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 41/62] spi: stm32: FIFO threshold level - fix align packet size
Date:   Fri, 15 Jan 2021 13:28:03 +0100
Message-Id: <20210115122000.381353872@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Guskov <rguskov@dh-electronics.com>

commit a590370d918fc66c62df6620445791fbe840344a upstream.

if cur_bpw <= 8 and xfer_len < 4 then the value of fthlv will be 1 and
SPI registers content may have been lost.

* If SPI data register is accessed as a 16-bit register and DSIZE <= 8bit,
  better to select FTHLV = 2, 4, 6 etc

* If SPI data register is accessed as a 32-bit register and DSIZE > 8bit,
  better to select FTHLV = 2, 4, 6 etc, while if DSIZE <= 8bit,
  better to select FTHLV = 4, 8, 12 etc

Signed-off-by: Roman Guskov <rguskov@dh-electronics.com>
Fixes: dcbe0d84dfa5 ("spi: add driver for STM32 SPI controller")
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20201221123532.27272-1-rguskov@dh-electronics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-stm32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -494,9 +494,9 @@ static u32 stm32h7_spi_prepare_fthlv(str
 
 	/* align packet size with data registers access */
 	if (spi->cur_bpw > 8)
-		fthlv -= (fthlv % 2); /* multiple of 2 */
+		fthlv += (fthlv % 2) ? 1 : 0;
 	else
-		fthlv -= (fthlv % 4); /* multiple of 4 */
+		fthlv += (fthlv % 4) ? (4 - (fthlv % 4)) : 0;
 
 	if (!fthlv)
 		fthlv = 1;


