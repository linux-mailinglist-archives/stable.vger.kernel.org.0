Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A77D46A9BB
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350899AbhLFVTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350916AbhLFVTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:19:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C6C0698D1;
        Mon,  6 Dec 2021 13:15:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CC77CE1864;
        Mon,  6 Dec 2021 21:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B6DC341C8;
        Mon,  6 Dec 2021 21:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825351;
        bh=ELH+il2Mf3EsnMMFH+0Rbjv4Z0olnhBGcL9NmlJwzNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jjr9Jv5nxDVIdYkaDZOyqk7i1XXMqrTAc9r5woNX8K74SZo+I0DgvupDOnW3qkkon
         KnBex+eU7LdoMnO1xZ8vIJtMfaWzi5BkhWvrDLGtsvcG8myy8qc8Js6WUL2XD7SXJT
         kIK2cM+mUpl2w1Ezr2y/82oben6fxnro6RUZvgB1JqAOUC7JLDXS8cuMk7FW8lUOmy
         COoain1vguuI8bH4Vl9HmzhG7Z9WhHXS/nilAavUb4Kse7g+5zU2THRmpn5VAym4+P
         vGkTk2v02rfSJP/1tAQxqG7KdZZms1dbEMtXpBbD6hnN8iFoUNYRRztH6FVX92afGj
         lLXfduzbBAnkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Peng Fan <peng.fan@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/15] Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"
Date:   Mon,  6 Dec 2021 16:15:04 -0500
Message-Id: <20211206211520.1660478-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211520.1660478-1-sashal@kernel.org>
References: <20211206211520.1660478-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

