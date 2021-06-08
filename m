Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB96B3A00E8
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhFHSsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhFHSqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:46:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E712A61459;
        Tue,  8 Jun 2021 18:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177467;
        bh=VqxFuZpzm+BtdNoy7fehz+noqK2WuQlyyMKYKtQbR7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pd8xhrNSUsq5kJ8PUG5ng7ob5Ry80GsAF33i1gi89qOdTni4AUY5Cbg1yvDuwTqt2
         nsdXGanjSgn+uxMK2XLnGYB4wxrYeyknhCZUURPvJ3KK8Yef9SSvt6hKBqc5XD0Q7X
         PNV8lG3723Lp2w3p0Gv98hKs9wOKL07m1GKgu3YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Ivan Jelincic <parazyd@dyne.org>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        "Sicelo A. Mhlongo" <absicsz@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/78] bus: ti-sysc: Fix flakey idling of uarts and stop using swsup_sidle_act
Date:   Tue,  8 Jun 2021 20:27:04 +0200
Message-Id: <20210608175936.447943522@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit c8692ad416dcc420ce1b403596a425c8f4c2720b ]

Looks like the swsup_sidle_act quirk handling is unreliable for serial
ports. The serial ports just eventually stop idling until woken up and
re-idled again. As the serial port not idling blocks any deeper SoC idle
states, it's adds an annoying random flakeyness for power management.

Let's just switch to swsup_sidle quirk instead like we already do for
omap3 uarts. This means we manually idle the port instead of trying to
use the hardware autoidle features when not in use.

For more details on why the serial ports have been using swsup_idle_act,
see commit 66dde54e978a ("ARM: OMAP2+: hwmod-data: UART IP needs software
control to manage sidle modes"). It seems that the swsup_idle_act quirk
handling is not enough though, and for example the TI Android kernel
changed to using swsup_sidle with commit 77c34c84e1e0 ("OMAP4: HWMOD:
UART1: disable smart-idle.").

Fixes: b4a9a7a38917 ("bus: ti-sysc: Handle swsup idle mode quirks")
Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Ivan Jelincic <parazyd@dyne.org>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sicelo A. Mhlongo <absicsz@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index d59e1ca9990b..90053c4a8290 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1376,9 +1376,9 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
 	/* Uarts on omap4 and later */
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x50411e03, 0xffff00ff,
-		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
+		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x47422e03, 0xffffffff,
-		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
+		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
 
 	/* Quirks that need to be set based on the module address */
 	SYSC_QUIRK("mcpdm", 0x40132000, 0, 0x10, -ENODEV, 0x50000800, 0xffffffff,
-- 
2.30.2



