Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9685C47FFB7
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhL0Pkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:40:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41656 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbhL0Pit (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:38:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0A51CE10D2;
        Mon, 27 Dec 2021 15:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92B7C36AEA;
        Mon, 27 Dec 2021 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619526;
        bh=pZOQ1woXoloJnOsX3Y3o1QHI0cJ5g7xWbmAlIDMfGHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdiRxS/dAavxLep0puYJ04j0biiLHy6s+4L0GbRkBnulf6UpgI46rVJ+PdjFw/qBm
         XJM49VF3SPmWm1fg9BT+VYBp0OakChJO9XCEBpQw0qlJTEmOs71oxX/hXqExeMveZS
         joJQ5L9szNhDu0dt1mG6eRB0mGOVMMCOHJfBgVVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Yann Gautier <yann.gautier@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 55/76] mmc: mmci: stm32: clear DLYB_CR after sending tuning command
Date:   Mon, 27 Dec 2021 16:31:10 +0100
Message-Id: <20211227151326.609217651@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yann Gautier <yann.gautier@foss.st.com>

commit ff31ee0a0f471776f67be5e5275c18d17736fc6b upstream.

During test campaign, and especially after several unbind/bind sequences,
it has been seen that the SD-card on SDMMC1 thread could freeze.
The freeze always appear on a CMD23 following a CMD19.
Checking SDMMC internal registers shows that the tuning command (CMD19)
has failed.
The freeze is then due to the delay block involved in the tuning sequence.
To correct this, clear the delay block register DLYB_CR register after
the tuning commands.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 1103f807a3b9 ("mmc: mmci_sdmmc: Add execute tuning with delay block")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211215141727.4901-4-yann.gautier@foss.st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci_stm32_sdmmc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -441,6 +441,8 @@ static int sdmmc_dlyb_phase_tuning(struc
 		return -EINVAL;
 	}
 
+	writel_relaxed(0, dlyb->base + DLYB_CR);
+
 	phase = end_of_len - max_len / 2;
 	sdmmc_dlyb_set_cfgr(dlyb, dlyb->unit, phase, false);
 


