Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF84F49A2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbfKHMEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:04:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389894AbfKHLmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48D84222C4;
        Fri,  8 Nov 2019 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213338;
        bh=0ygN0E9IlVH1H4ShoeoX+2esYHh+PfpGzBtEyMhLJ2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6O6Lr6NnF47wbVRc8tCKRY5ASg2k+EOXxu6CA6qVe8CX0UArk98Ee0GvbzSAFYXC
         xmEDHUFJVtxyqY9Jwqa6elgoqFli+GiwiyKujMfSm4XAwQ3ixR0SJnXW7EOk42DnMb
         VAoFT1cGE9CpjfW3y0GkCa6/Cl+NNhcy3FGEKtGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 175/205] soc: qcom: geni: geni_se_clk_freq_match() should always accept multiples
Date:   Fri,  8 Nov 2019 06:37:22 -0500
Message-Id: <20191108113752.12502-175-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 867d4aa7013fdee8b962cde1711f96c8dd86d926 ]

The geni_se_clk_freq_match() has some strange semantics.  Specifically
it is defined with two modes:
1. It can find a clock that's an exact multiple of the requested rate
2. It can find a non-exact match but it can't handle multiples then

...but callers should always be able to handle a clock that is a
multiple of the requested clock so mode #2 doesn't really make sense.
Let's change the semantics so that the non-exact match can also accept
multiples and then change the code to handle that.

The only caller of this code is the unlanded SPI driver [1] which
currently passes "exact = True", thus it should be safe to change the
semantics in this way.  ...and, in fact, the SPI driver should likely
be modified to pass "exact = False" (with the new semantics) since
that will allow it to work with SPI devices that request a clock rate
that doesn't exactly match a rate we can make.

[1] https://lkml.kernel.org/r/1535107336-2214-1-git-send-email-dkota@codeaurora.org

Fixes: eddac5af0654 ("soc: qcom: Add GENI based QUP Wrapper driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 37 ++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 1b19b8428c4ac..ee89ffb6dde84 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -544,16 +544,17 @@ EXPORT_SYMBOL(geni_se_clk_tbl_get);
  * @se:		Pointer to the concerned serial engine.
  * @req_freq:	Requested clock frequency.
  * @index:	Index of the resultant frequency in the table.
- * @res_freq:	Resultant frequency which matches or is closer to the
- *		requested frequency.
+ * @res_freq:	Resultant frequency of the source clock.
  * @exact:	Flag to indicate exact multiple requirement of the requested
  *		frequency.
  *
- * This function is called by the protocol drivers to determine the matching
- * or exact multiple of the requested frequency, as provided by the serial
- * engine clock in order to meet the performance requirements. If there is
- * no matching or exact multiple of the requested frequency found, then it
- * selects the closest floor frequency, if exact flag is not set.
+ * This function is called by the protocol drivers to determine the best match
+ * of the requested frequency as provided by the serial engine clock in order
+ * to meet the performance requirements.
+ *
+ * If we return success:
+ * - if @exact is true  then @res_freq / <an_integer> == @req_freq
+ * - if @exact is false then @res_freq / <an_integer> <= @req_freq
  *
  * Return: 0 on success, standard Linux error codes on failure.
  */
@@ -564,6 +565,9 @@ int geni_se_clk_freq_match(struct geni_se *se, unsigned long req_freq,
 	unsigned long *tbl;
 	int num_clk_levels;
 	int i;
+	unsigned long best_delta;
+	unsigned long new_delta;
+	unsigned int divider;
 
 	num_clk_levels = geni_se_clk_tbl_get(se, &tbl);
 	if (num_clk_levels < 0)
@@ -572,18 +576,21 @@ int geni_se_clk_freq_match(struct geni_se *se, unsigned long req_freq,
 	if (num_clk_levels == 0)
 		return -EINVAL;
 
-	*res_freq = 0;
+	best_delta = ULONG_MAX;
 	for (i = 0; i < num_clk_levels; i++) {
-		if (!(tbl[i] % req_freq)) {
+		divider = DIV_ROUND_UP(tbl[i], req_freq);
+		new_delta = req_freq - tbl[i] / divider;
+		if (new_delta < best_delta) {
+			/* We have a new best! */
 			*index = i;
 			*res_freq = tbl[i];
-			return 0;
-		}
 
-		if (!(*res_freq) || ((tbl[i] > *res_freq) &&
-				     (tbl[i] < req_freq))) {
-			*index = i;
-			*res_freq = tbl[i];
+			/* If the new best is exact then we're done */
+			if (new_delta == 0)
+				return 0;
+
+			/* Record how close we got */
+			best_delta = new_delta;
 		}
 	}
 
-- 
2.20.1

