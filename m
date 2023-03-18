Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475BF6BFA3C
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjCRNaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 09:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCRNaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 09:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D816D303FE;
        Sat, 18 Mar 2023 06:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A6D760C69;
        Sat, 18 Mar 2023 13:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD4FC433D2;
        Sat, 18 Mar 2023 13:30:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WKCKR3gP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1679146217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nqr/nUnieHd8r4zheNL21KlePfDeA8yZBuwwN9r8k3A=;
        b=WKCKR3gP1Tnb355ZsuLfODImva+5vZoE0VRH5sszMUhW7DjWsC/OybL9flZ/lNbuW6gQql
        DmKVIZhdh0+7BU3uNdllcMFYumCKzKC1phn+GS/dnbzDQkqhLCIxNWCO7VRakLHilNFiur
        EPGaVd7JdsozAfyFHeiXcDVj/TBOiK4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 33af9d47 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 18 Mar 2023 13:30:17 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        regressions@leemhuis.info, barry@messagefor.me.uk
Subject: [PATCH] Input: focaltech - use explicitly signed char type
Date:   Sat, 18 Mar 2023 14:30:10 +0100
Message-Id: <20230318133010.1285202-1-Jason@zx2c4.com>
In-Reply-To: <e20db4c4-b2a8-bc88-232f-d1213733d20c@leemhuis.info>
References: <e20db4c4-b2a8-bc88-232f-d1213733d20c@leemhuis.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The recent change of -funsigned-char causes additions of negative
numbers to become additions of large positive numbers, leading to wrong
calculations of mouse movement. Change these casts to be explictly
signed, to take into account negative offsets.

Fixes: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Cc: stable@vger.kernel.org
Cc: regressions@leemhuis.info
Cc: barry@messagefor.me.uk
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Wrote this patch from my phone, untested, so it would be nice if
somebody with hardware could confirm it works.

 drivers/input/mouse/focaltech.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/focaltech.c b/drivers/input/mouse/focaltech.c
index 6fd5fff0cbff..3dbad0d8e8c9 100644
--- a/drivers/input/mouse/focaltech.c
+++ b/drivers/input/mouse/focaltech.c
@@ -202,8 +202,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	state->pressed = packet[0] >> 7;
 	finger1 = ((packet[0] >> 4) & 0x7) - 1;
 	if (finger1 < FOC_MAX_FINGERS) {
-		state->fingers[finger1].x += (char)packet[1];
-		state->fingers[finger1].y += (char)packet[2];
+		state->fingers[finger1].x += (signed char)packet[1];
+		state->fingers[finger1].y += (signed char)packet[2];
 	} else {
 		psmouse_err(psmouse, "First finger in rel packet invalid: %d\n",
 			    finger1);
@@ -218,8 +218,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	 */
 	finger2 = ((packet[3] >> 4) & 0x7) - 1;
 	if (finger2 < FOC_MAX_FINGERS) {
-		state->fingers[finger2].x += (char)packet[4];
-		state->fingers[finger2].y += (char)packet[5];
+		state->fingers[finger2].x += (signed char)packet[4];
+		state->fingers[finger2].y += (signed char)packet[5];
 	}
 }
 
-- 
2.40.0

