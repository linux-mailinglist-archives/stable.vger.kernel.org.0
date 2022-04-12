Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C974FDAC7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377096AbiDLHrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357271AbiDLHjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F2CDFFB;
        Tue, 12 Apr 2022 00:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8522561045;
        Tue, 12 Apr 2022 07:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEDFC385A1;
        Tue, 12 Apr 2022 07:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747675;
        bh=vAiDl1GwVbQ82UKpOaMdXzGgdpkyRkO6Fv8harzJaY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJEPD98mgdrCaH7jXoTlUJrCY6SMP2Fxvpz2G+6X0891E5/JYE7ZiskqJ69qlpv3d
         p27R8hsz0iVvvdOKso+mgVtAJzlkEDdVCk3B8ITGjEGQKAoXuz5fEjCg70UgYxOz0d
         JqxB2kontUorx/9oihrImgD5P6OWuuirbHK9l8gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 166/343] staging: wfx: apply the necessary SDIO quirks for the Silabs WF200
Date:   Tue, 12 Apr 2022 08:29:44 +0200
Message-Id: <20220412062956.162857858@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 96e0cbca1cb96e9d3deac3051aa816e13082f3fd ]

Until now, the SDIO quirks are applied directly from the driver.
However, it is better to apply the quirks before driver probing. So,
this patch relocate the quirks in the MMC framework.

Note that the WF200 has no valid SDIO VID/PID. Therefore, we match DT
rather than on the SDIO VID/PID.

Reviewed-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20220216093112.92469-3-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/quirks.h      | 5 +++++
 drivers/staging/wfx/bus_sdio.c | 3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index 20f568727277..f879dc63d936 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -149,6 +149,11 @@ static const struct mmc_fixup __maybe_unused sdio_fixup_methods[] = {
 static const struct mmc_fixup __maybe_unused sdio_card_init_methods[] = {
 	SDIO_FIXUP_COMPATIBLE("ti,wl1251", wl1251_quirk, 0),
 
+	SDIO_FIXUP_COMPATIBLE("silabs,wf200", add_quirk,
+			      MMC_QUIRK_BROKEN_BYTE_MODE_512 |
+			      MMC_QUIRK_LENIENT_FN0 |
+			      MMC_QUIRK_BLKSZ_FOR_BYTE_MODE),
+
 	END_FIXUP
 };
 
diff --git a/drivers/staging/wfx/bus_sdio.c b/drivers/staging/wfx/bus_sdio.c
index a670176ba06f..0612f8a7c085 100644
--- a/drivers/staging/wfx/bus_sdio.c
+++ b/drivers/staging/wfx/bus_sdio.c
@@ -207,9 +207,6 @@ static int wfx_sdio_probe(struct sdio_func *func,
 
 	bus->func = func;
 	sdio_set_drvdata(func, bus);
-	func->card->quirks |= MMC_QUIRK_LENIENT_FN0 |
-			      MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
-			      MMC_QUIRK_BROKEN_BYTE_MODE_512;
 
 	sdio_claim_host(func);
 	ret = sdio_enable_func(func);
-- 
2.35.1



