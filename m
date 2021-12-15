Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77215475ED9
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245657AbhLORZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245371AbhLORYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50E3C061574;
        Wed, 15 Dec 2021 09:24:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53322619EB;
        Wed, 15 Dec 2021 17:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382F2C36AE0;
        Wed, 15 Dec 2021 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589062;
        bh=1kNzIlA7OK/d4j0WjBCGRmP3H3raho0VDYTDXBHSWCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5q5LG7a1QLYbXgcrBLUoys3ylWZFIvFSknmwJtuFB4ZDAVNhwmlZ8stK8Wq9SAu9
         +XSUe2kGPCPcChqmnAl0EXUbcQCvtN0gJO26sM+D8IECacc7sfw4iE21XXS6I2adQv
         KUhMo6ivrINqFRWcNKfGkqWMHRMD0/uSG+NM9yTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/42] Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"
Date:   Wed, 15 Dec 2021 18:21:06 +0100
Message-Id: <20211215172027.533691416@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 4e9679738a918d8a482ac6a2cb2bb871f094bb84 ]

Revert commit b4b844930f27 ("tty: serial: fsl_lpuart: drop earlycon entry
for i.MX8QXP"), because this breaks earlycon support on imx8qm/imx8qxp.
While it is true that for earlycon there is no difference between
i.MX8QXP and i.MX7ULP (for now at least), there are differences
regarding clocks and fixups for wakeup support. For that reason it was
deemed unacceptable to add the imx7ulp compatible to device tree in
order to get earlycon working again.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20211124073109.805088-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index b1e7190ae4836..ac5112def40d1 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2625,6 +2625,7 @@ OF_EARLYCON_DECLARE(lpuart, "fsl,vf610-lpuart", lpuart_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1021a-lpuart", lpuart32_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1028a-lpuart", ls1028a_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx7ulp-lpuart", lpuart32_imx_early_console_setup);
+OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8qxp-lpuart", lpuart32_imx_early_console_setup);
 EARLYCON_DECLARE(lpuart, lpuart_early_console_setup);
 EARLYCON_DECLARE(lpuart32, lpuart32_early_console_setup);
 
-- 
2.33.0



