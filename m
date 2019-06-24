Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B98950789
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbfFXKHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730359AbfFXKHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:48 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F3BA20644;
        Mon, 24 Jun 2019 10:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370867;
        bh=k1UeBPaMg9crGnvIX9XG0jozyYs+NYomN/H3UaM7mo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgKnEw4jwhrs66XvYA04HnAM8W2/nUfcUhkrqDlyDGwMBF0cXoyR4Zb2WLsARDLOw
         +P2z2Y3jzj9501iAXw1hZBScsKJ2fsTRzINdmceaGBrXxqLulcMWN51SnHEAQlgi7d
         TVJxI/NCu4y8MHv/M81IOpGvyTbk1V+7LCAq27Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.1 003/121] mmc: sdhi: disallow HS400 for M3-W ES1.2, RZ/G2M, and V3H
Date:   Mon, 24 Jun 2019 17:55:35 +0800
Message-Id: <20190624092320.828212800@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 97bf85b6ec9e6597ce81c79b26a28f7918fc4eaf upstream.

Our HW engineers informed us that HS400 is not working on these SoC
revisions.

Fixes: 0f4e2054c971 ("mmc: renesas_sdhi: disable HS400 on H3 ES1.x and M3-W ES1.[012]")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/renesas_sdhi_core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -620,11 +620,16 @@ static const struct renesas_sdhi_quirks
 	.hs400_4taps = true,
 };
 
+static const struct renesas_sdhi_quirks sdhi_quirks_nohs400 = {
+	.hs400_disabled = true,
+};
+
 static const struct soc_device_attribute sdhi_quirks_match[]  = {
 	{ .soc_id = "r8a7795", .revision = "ES1.*", .data = &sdhi_quirks_h3_m3w_es1 },
 	{ .soc_id = "r8a7795", .revision = "ES2.0", .data = &sdhi_quirks_h3_es2 },
-	{ .soc_id = "r8a7796", .revision = "ES1.0", .data = &sdhi_quirks_h3_m3w_es1 },
-	{ .soc_id = "r8a7796", .revision = "ES1.1", .data = &sdhi_quirks_h3_m3w_es1 },
+	{ .soc_id = "r8a7796", .revision = "ES1.[012]", .data = &sdhi_quirks_h3_m3w_es1 },
+	{ .soc_id = "r8a774a1", .revision = "ES1.[012]", .data = &sdhi_quirks_h3_m3w_es1 },
+	{ .soc_id = "r8a77980", .data = &sdhi_quirks_nohs400 },
 	{ /* Sentinel. */ },
 };
 


