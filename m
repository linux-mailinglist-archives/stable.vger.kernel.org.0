Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13234304AED
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbhAZEyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbhAYSr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48AC2230FA;
        Mon, 25 Jan 2021 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600460;
        bh=8/n197WWxFF7Liv056co3I4ULU751T8Zt5vCREeLy1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zW7btDD6v5vzaupRjL7jlZqZwYKUsO2n9S95IsxzbE/2TzBOMYQ3rmxeyueEtYuR1
         yTHV2i1YtO8t+CaT+0Wb2134PI2+yLGBlP0OL2gvjU64AxwBKdhW3RQ50HNUMnfqmW
         WgmwZcKkj2BY0uQ/vmB5DRzvdyosNOv8g+50Bdus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 004/199] i2c: tegra: Wait for config load atomically while in ISR
Date:   Mon, 25 Jan 2021 19:37:06 +0100
Message-Id: <20210125183216.438507060@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

commit 27b7c6e096264cc7b91bb80a4f65f8c0a66f079f upstream.

Upon a communication error, the interrupt handler can call
tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
unless the current transaction was marked atomic. Fix this by
making the poll happen atomically if we are in an IRQ.

This matches the behavior prior to the patch mentioned
in the Fixes tag.

Fixes: ede2299f7101 ("i2c: tegra: Support atomic transfers")
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -533,7 +533,7 @@ static int tegra_i2c_poll_register(struc
 	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
 	u32 val;
 
-	if (!i2c_dev->atomic_mode)
+	if (!i2c_dev->atomic_mode && !in_irq())
 		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
 						  delay_us, timeout_us);
 


