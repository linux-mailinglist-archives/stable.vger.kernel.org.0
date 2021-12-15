Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7CD475F0E
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245693AbhLOR12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbhLORZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E1C061757;
        Wed, 15 Dec 2021 09:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F2C8B82049;
        Wed, 15 Dec 2021 17:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42459C36AE3;
        Wed, 15 Dec 2021 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589118;
        bh=ELH+il2Mf3EsnMMFH+0Rbjv4Z0olnhBGcL9NmlJwzNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvW2nP6RwM5UetPQQRcmkmGeZ2RTAArETir+StwP7M/ceH9zEd46i+R+uWBGR8GEG
         crB29Knsc7qATaf7RKz6i5qqMko7VB9/6/QGnf9jKm27gP0YqYMML1lxChYTVvzZWZ
         D+xVi8q/fFOxeVP4gYRg+hoXdsqyesUOJ1M7/8D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/33] Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"
Date:   Wed, 15 Dec 2021 18:21:03 +0100
Message-Id: <20211215172024.968919929@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
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
index a70911a227a84..b9f8add284e33 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2559,6 +2559,7 @@ OF_EARLYCON_DECLARE(lpuart, "fsl,vf610-lpuart", lpuart_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1021a-lpuart", lpuart32_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1028a-lpuart", ls1028a_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx7ulp-lpuart", lpuart32_imx_early_console_setup);
+OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8qxp-lpuart", lpuart32_imx_early_console_setup);
 EARLYCON_DECLARE(lpuart, lpuart_early_console_setup);
 EARLYCON_DECLARE(lpuart32, lpuart32_early_console_setup);
 
-- 
2.33.0



