Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A159E1CAB87
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgEHMo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgEHMo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B152145D;
        Fri,  8 May 2020 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941867;
        bh=ntFx9cisOC5WEGR9NgoQJkp5UtAujJ3Z17jpEpWqYz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQKrmklLuJ3wHhF7BU8GQb99vahwrEgnEZ78m8cvQISomyobjrQnaSlclIa1W9xMF
         btxQQLr+aqXO45ez21BORlEPqAdNdPDQApjn6GxlIpa5kgUFqYB5Xj7SFm5hmYGgb+
         oChVCBO5MKW7whA+GGf9RCMUl39piB0EXnRDNxyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michael Turquette <mturquette@baylibre.com>
Subject: [PATCH 4.4 205/312] clk: multiplier: Prevent the multiplier from under / over flowing
Date:   Fri,  8 May 2020 14:33:16 +0200
Message-Id: <20200508123138.843408939@linuxfoundation.org>
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

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit 25f77a3aa4cb948666bf8e7fd972533ea487c3bd upstream.

In the current multiplier base clock implementation, if the
CLK_SET_RATE_PARENT flag isn't set, the code will not make sure that the
multiplier computed remains within the boundaries of our clock.

This means that if the clock we want to reach is below the parent rate,
or if the multiplier is above the maximum that we can reach, we will end up
with a completely bogus one that the clock cannot achieve.

Fixes: f2e0a53271a4 ("clk: Add a basic multiplier clock")
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Michael Turquette <mturquette@baylibre.com>
Link: lkml.kernel.org/r/1463402840-17062-3-git-send-email-maxime.ripard@free-electrons.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-multiplier.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/clk/clk-multiplier.c
+++ b/drivers/clk/clk-multiplier.c
@@ -54,14 +54,28 @@ static unsigned long __bestmult(struct c
 				unsigned long *best_parent_rate,
 				u8 width, unsigned long flags)
 {
+	struct clk_multiplier *mult = to_clk_multiplier(hw);
 	unsigned long orig_parent_rate = *best_parent_rate;
 	unsigned long parent_rate, current_rate, best_rate = ~0;
 	unsigned int i, bestmult = 0;
+	unsigned int maxmult = (1 << width) - 1;
 
-	if (!(clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT))
-		return rate / *best_parent_rate;
+	if (!(clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT)) {
+		bestmult = rate / orig_parent_rate;
 
-	for (i = 1; i < ((1 << width) - 1); i++) {
+		/* Make sure we don't end up with a 0 multiplier */
+		if ((bestmult == 0) &&
+		    !(mult->flags & CLK_MULTIPLIER_ZERO_BYPASS))
+			bestmult = 1;
+
+		/* Make sure we don't overflow the multiplier */
+		if (bestmult > maxmult)
+			bestmult = maxmult;
+
+		return bestmult;
+	}
+
+	for (i = 1; i < maxmult; i++) {
 		if (rate == orig_parent_rate * i) {
 			/*
 			 * This is the best case for us if we have a


