Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29B53961DB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhEaOrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234245AbhEaOpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9612A61C7E;
        Mon, 31 May 2021 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469318;
        bh=LaB3UTQvPX++WABDJkqPhH0V1OsEQ6q1tF4fYa/kK94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrFJyFiboCmm6tF9GQrwAPf9muhUdnOhkIYpT3ssW/ynB9qWEF0+YaiOCY5yXV0fk
         DAnDlLI4hpnUbE2Y6gmZxcvM6Bfj1dU8uFJ37hsm48sdaz/gGKIfIvPv+8qxJqs1aj
         Yie1O6UmnrvQhwMJd+H8myYcu7c20QdovOJt0AYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.12 152/296] i2c: sh_mobile: Use new clock calculation formulas for RZ/G2E
Date:   Mon, 31 May 2021 15:13:27 +0200
Message-Id: <20210531130708.977765480@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit c4740e293c93c747e65d53d9aacc2ba8521d1489 upstream.

When switching the Gen3 SoCs to the new clock calculation formulas, the
match entry for RZ/G2E added in commit 51243b73455f2d12 ("i2c:
sh_mobile: Add support for r8a774c0 (RZ/G2E)") was forgotten.

Fixes: e8a27567509b2439 ("i2c: sh_mobile: use new clock calculation formulas for Gen3")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-sh_mobile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -807,7 +807,7 @@ static const struct sh_mobile_dt_config
 static const struct of_device_id sh_mobile_i2c_dt_ids[] = {
 	{ .compatible = "renesas,iic-r8a73a4", .data = &fast_clock_dt_config },
 	{ .compatible = "renesas,iic-r8a7740", .data = &r8a7740_dt_config },
-	{ .compatible = "renesas,iic-r8a774c0", .data = &fast_clock_dt_config },
+	{ .compatible = "renesas,iic-r8a774c0", .data = &v2_freq_calc_dt_config },
 	{ .compatible = "renesas,iic-r8a7790", .data = &v2_freq_calc_dt_config },
 	{ .compatible = "renesas,iic-r8a7791", .data = &v2_freq_calc_dt_config },
 	{ .compatible = "renesas,iic-r8a7792", .data = &v2_freq_calc_dt_config },


