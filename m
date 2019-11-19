Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043EC101859
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfKSFcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfKSFcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619D621783;
        Tue, 19 Nov 2019 05:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141568;
        bh=0ygN0E9IlVH1H4ShoeoX+2esYHh+PfpGzBtEyMhLJ2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzmUmMZmx6FBpPHgz6okxTqu+qqP0jQYZrzdNrkrZtYSotWQ7p/sg97xsWUDcL8qc
         KncXDmiWKsgA3dlqL2Ddd+YmYdNUDAStL334lopSW1o60MMHEow4RR0l5PudcQ4xkV
         Np4/rHYP3rVmmoUaOfkxGx52RWDJXkKjvj7iKLiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 205/422] soc: qcom: geni: geni_se_clk_freq_match() should always accept multiples
Date:   Tue, 19 Nov 2019 06:16:42 +0100
Message-Id: <20191119051411.870960041@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



