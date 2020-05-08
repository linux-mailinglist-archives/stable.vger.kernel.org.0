Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E671D1CAF53
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEHNRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgEHMoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC132145D;
        Fri,  8 May 2020 12:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941860;
        bh=irPrTDwb1kvQaEoK/vdNjVAPtwRhIg9KA8FpipZ/8Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsWZVHypTxLv5BRhADsWSvCqmw3ABwbeeb2Alud7wZ3be4YrUfS90YbTCBIIZx2v8
         ptPCFaQoZaFZGtaLcoBdiVOq7cApZxaFmX7degjXfnw7f7F3SqlqHAlxFtpS7rwmP7
         qXPgSJdOhSj9U9MlSv2TQPf7uaii87Eq1eHd2+Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 4.4 202/312] clk: st: avoid uninitialized variable use
Date:   Fri,  8 May 2020 14:33:13 +0200
Message-Id: <20200508123138.639262427@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 2dd52d7f6f9d9d03a82a68040ac3d221dd79af94 upstream.

quadfs_pll_fs660c32_round_rate prints a few structure members
that are never initialized, and also doesn't print the only one
it cares about. We get a gcc warning about the ones that
are printed:

clk/st/clkgen-fsyn.c:560:93: warning: 'params.sdiv' may be used uninitialized in this function
clk/st/clkgen-fsyn.c:560:93: warning: 'params.mdiv' may be used uninitialized in this function
clk/st/clkgen-fsyn.c:560:93: warning: 'params.pe' may be used uninitialized in this function
clk/st/clkgen-fsyn.c:560:93: warning: 'params.nsdiv' may be used uninitialized in this function

This changes the code to no longer print uninitialized data, and
for good measure it also prints the ndiv member that is being
set.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 5f7aa9071e93 ("clk: st: Support for QUADFS inside ClockGenB/C/D/E/F")
Acked-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/st/clkgen-fsyn.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -549,19 +549,20 @@ static int clk_fs660c32_vco_get_params(u
 	return 0;
 }
 
-static long quadfs_pll_fs660c32_round_rate(struct clk_hw *hw, unsigned long rate
-		, unsigned long *prate)
+static long quadfs_pll_fs660c32_round_rate(struct clk_hw *hw,
+					   unsigned long rate,
+					   unsigned long *prate)
 {
 	struct stm_fs params;
 
-	if (!clk_fs660c32_vco_get_params(*prate, rate, &params))
-		clk_fs660c32_vco_get_rate(*prate, &params, &rate);
+	if (clk_fs660c32_vco_get_params(*prate, rate, &params))
+		return rate;
 
-	pr_debug("%s: %s new rate %ld [sdiv=0x%x,md=0x%x,pe=0x%x,nsdiv3=%u]\n",
+	clk_fs660c32_vco_get_rate(*prate, &params, &rate);
+
+	pr_debug("%s: %s new rate %ld [ndiv=%u]\n",
 		 __func__, clk_hw_get_name(hw),
-		 rate, (unsigned int)params.sdiv,
-		 (unsigned int)params.mdiv,
-		 (unsigned int)params.pe, (unsigned int)params.nsdiv);
+		 rate, (unsigned int)params.ndiv);
 
 	return rate;
 }


