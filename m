Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214AC694935
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBMO5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjBMO5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:57:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1541DBA3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:56:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FECCB81261
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E70DC433D2;
        Mon, 13 Feb 2023 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300179;
        bh=lyevsOS1FrjFBTNnMLuOxMuDX3zTzhdNJg2mHwOxnCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWIayWDGslondqBSFDCuVbjm3IqV51hgDFFfM8nmt5n4RxxVyuehnAr+0stW8MdRk
         wLFomvuJOXHarE3snlSgT7PFkeSgpGw+Z3HgyDV2INdfUOIfsMuxP8xOhAlmByhFBd
         kWuiJ/cMrzlo3KiQGMMcXHv95LTW1DdKfcpA4U1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.1 089/114] clk: ingenic: jz4760: Update M/N/OD calculation algorithm
Date:   Mon, 13 Feb 2023 15:48:44 +0100
Message-Id: <20230213144746.751740093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit ecfb9f404771dde909ce7743df954370933c3be2 upstream.

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
Link: https://lore.kernel.org/r/20221214123704.7305-1-paul@crapouillou.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/ingenic/jz4760-cgu.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/clk/ingenic/jz4760-cgu.c
+++ b/drivers/clk/ingenic/jz4760-cgu.c
@@ -58,7 +58,7 @@ jz4760_cgu_calc_m_n_od(const struct inge
 		       unsigned long rate, unsigned long parent_rate,
 		       unsigned int *pm, unsigned int *pn, unsigned int *pod)
 {
-	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 2;
+	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 1;
 
 	/* The frequency after the N divider must be between 1 and 50 MHz. */
 	n = parent_rate / (1 * MHZ);
@@ -66,19 +66,17 @@ jz4760_cgu_calc_m_n_od(const struct inge
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
 


