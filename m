Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616F364C922
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 13:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbiLNMjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 07:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238297AbiLNMil (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 07:38:41 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801CC23BC3;
        Wed, 14 Dec 2022 04:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1671021430; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=HLzDDpFo+NMrWAFFyUZ9LuVUJTHVwxs+VXTyDfaqs9Q=;
        b=xop6fV11aNUmenrUx59Oup4N5Niw2ZMg1q1ul/H5H7lsj2z9Ci1uiyTU528q8AiTyTzSCP
        gX69xAHuHtARmUqSyjNNI+M61CdYnQeokcms2dEbkWQmRs8yugxr9XwDNztgvl89Cy9d/I
        IpUOFSv9WkaFsPih5Lo7Ai3EzrPj3vI=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH] clk: ingenic: jz4760: Update M/N/OD calculation algorithm
Date:   Wed, 14 Dec 2022 13:37:04 +0100
Message-Id: <20221214123704.7305-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The previous algorithm was pretty broken.

- The inner loop had a '(m > m_max)' condition, and the value of 'm'
  would increase in each iteration;

- Each iteration would actually multiply 'm' by two, so it is not needed
  to re-compute the whole equation at each iteration;

- It would loop until (m & 1) == 0, which means it would loop at most
  once.

- The outer loop would divide the 'n' value by two at the end of each
  iteration. This meant that for a 12 MHz parent clock and a 1.2 GHz
  requested clock, it would first try n=12, then n=6, then n=3, then
  n=1, none of which would work; the only valid value is n=2 in this
  case.

Simplify this algorithm with a single for loop, which decrements 'n'
after each iteration, addressing all of the above problems.

Fixes: bdbfc029374f ("clk: ingenic: Add support for the JZ4760")
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/clk/ingenic/jz4760-cgu.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/ingenic/jz4760-cgu.c b/drivers/clk/ingenic/jz4760-cgu.c
index ecd395ac8a28..e407f00bd594 100644
--- a/drivers/clk/ingenic/jz4760-cgu.c
+++ b/drivers/clk/ingenic/jz4760-cgu.c
@@ -58,7 +58,7 @@ jz4760_cgu_calc_m_n_od(const struct ingenic_cgu_pll_info *pll_info,
 		       unsigned long rate, unsigned long parent_rate,
 		       unsigned int *pm, unsigned int *pn, unsigned int *pod)
 {
-	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 2;
+	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 1;
 
 	/* The frequency after the N divider must be between 1 and 50 MHz. */
 	n = parent_rate / (1 * MHZ);
@@ -66,19 +66,17 @@ jz4760_cgu_calc_m_n_od(const struct ingenic_cgu_pll_info *pll_info,
 	/* The N divider must be >= 2. */
 	n = clamp_val(n, 2, 1 << pll_info->n_bits);
 
-	for (;; n >>= 1) {
-		od = (unsigned int)-1;
+	rate /= MHZ;
+	parent_rate /= MHZ;
 
-		do {
-			m = (rate / MHZ) * (1 << ++od) * n / (parent_rate / MHZ);
-		} while ((m > m_max || m & 1) && (od < 4));
-
-		if (od < 4 && m >= 4 && m <= m_max)
-			break;
+	for (m = m_max; m >= m_max && n >= 2; n--) {
+		m = rate * n / parent_rate;
+		od = m & 1;
+		m <<= od;
 	}
 
 	*pm = m;
-	*pn = n;
+	*pn = n + 1;
 	*pod = 1 << od;
 }
 
-- 
2.35.1

