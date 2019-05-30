Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1989A2F405
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfE3DNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbfE3DNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:20 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E8321BE2;
        Thu, 30 May 2019 03:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185999;
        bh=xLK+GB7522f2QXrf/TUYNcfRXdrfcjqNLXPFEZK22mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1BVHODi4vGRR4G/wGgAicb82Yt/4SckaWrQG3q7paPQ3zLrt91ea9oNJm2JyIpuL
         SX9SixnkYMb70QXWTnVVjWop4KWQW8b7rXx7qcuQ/2OLeUsvrQJjmAURAypLjU2pOL
         iiC3lgAJIHrSsCKQRWy+ORLeFJrJlfoPFjC/YVTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Raul E Rangel <rrangel@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 049/346] mmc: core: Verify SD bus width
Date:   Wed, 29 May 2019 20:02:02 -0700
Message-Id: <20190530030543.388979520@linuxfoundation.org>
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

[ Upstream commit 9e4be8d03f50d1b25c38e2b59e73b194c130df7d ]

The SD Physical Layer Spec says the following: Since the SD Memory Card
shall support at least the two bus modes 1-bit or 4-bit width, then any SD
Card shall set at least bits 0 and 2 (SD_BUS_WIDTH="0101").

This change verifies the card has specified a bus width.

AMD SDHC Device 7806 can get into a bad state after a card disconnect
where anything transferred via the DATA lines will always result in a
zero filled buffer. Currently the driver will continue without error if
the HC is in this condition. A block device will be created, but reading
from it will result in a zero buffer. This makes it seem like the SD
device has been erased, when in actuality the data is never getting
copied from the DATA lines to the data buffer.

SCR is the first command in the SD initialization sequence that uses the
DATA lines. By checking that the response was invalid, we can abort
mounting the card.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index d0d9f90e7cdfb..cfb8ee24eaba1 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -216,6 +216,14 @@ static int mmc_decode_scr(struct mmc_card *card)
 
 	if (scr->sda_spec3)
 		scr->cmds = UNSTUFF_BITS(resp, 32, 2);
+
+	/* SD Spec says: any SD Card shall set at least bits 0 and 2 */
+	if (!(scr->bus_widths & SD_SCR_BUS_WIDTH_1) ||
+	    !(scr->bus_widths & SD_SCR_BUS_WIDTH_4)) {
+		pr_err("%s: invalid bus width\n", mmc_hostname(card->host));
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.20.1



