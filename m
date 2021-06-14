Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0523A63EA
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbhFNLSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235549AbhFNLQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3D996196A;
        Mon, 14 Jun 2021 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667812;
        bh=j7cxBDtCIikpzGwmTnc+//5Mw/Dr1B6zUBTs45B9AUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDIguhMBFPVsN6jxIBPg+1Wn7XwCLMoLc7hnUA1e5WCpzeHZZ0uGsNzowBeBK98wn
         R1oUuJHJZ0i1BRNSIEymRoxQgLh2MOcuHVJuzcpK/RW60RG/X1pb36K+iWUa43RHcQ
         s2loUizE5yVQXHZNCJkmuw3NPg1KB8p53yXhAdws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.12 084/173] mmc: renesas_sdhi: Fix HS400 on R-Car M3-W+
Date:   Mon, 14 Jun 2021 12:26:56 +0200
Message-Id: <20210614102700.961426872@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 6687cd72aa9112a454a4646986e0402dd1b07d0e upstream.

R-Car M3-W ES3.0 is marketed as R-Car M3-W+ (R8A77961), and has its own
compatible value "renesas,r8a77961".

Hence using soc_device_match() with soc_id = "r8a7796" and revision =
"ES3.*" does not actually match running on an R-Car M3-W+ SoC.

Fix this by matching with soc_id = "r8a77961" instead.

Fixes: a38c078fea0b1393 ("mmc: renesas_sdhi: Avoid bad TAP in HS400")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/ee8af5d631f5331139ffea714539030d97352e93.1622811525.git.geert+renesas@glider.be
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -931,7 +931,7 @@ static const struct soc_device_attribute
 	{ .soc_id = "r8a7795", .revision = "ES3.*", .data = &sdhi_quirks_bad_taps2367 },
 	{ .soc_id = "r8a7796", .revision = "ES1.[012]", .data = &sdhi_quirks_4tap_nohs400 },
 	{ .soc_id = "r8a7796", .revision = "ES1.*", .data = &sdhi_quirks_r8a7796_es13 },
-	{ .soc_id = "r8a7796", .revision = "ES3.*", .data = &sdhi_quirks_bad_taps1357 },
+	{ .soc_id = "r8a77961", .data = &sdhi_quirks_bad_taps1357 },
 	{ .soc_id = "r8a77965", .data = &sdhi_quirks_r8a77965 },
 	{ .soc_id = "r8a77980", .data = &sdhi_quirks_nohs400 },
 	{ .soc_id = "r8a77990", .data = &sdhi_quirks_r8a77990 },


