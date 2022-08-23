Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A059DA5D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352367AbiHWKH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352820AbiHWKGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC54D1E0;
        Tue, 23 Aug 2022 01:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65A66CE1B41;
        Tue, 23 Aug 2022 08:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F57C433D6;
        Tue, 23 Aug 2022 08:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244790;
        bh=wfxCBtMasHoEFMn9oqLYg4hdLmiDL38+6fTcxBgzW1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iI8VXE41VYyu8+fkTbYT4s+JZ7gxRmyC6XGsQ3u+V0+d2RdtorTwkGG3GXuirO2MN
         p5Ub47d5beX6dbfXKK4TH1Wj5I6SNs8mClaSOBON5TBVduB2+V4OWbikOuaCDKxUZV
         vjW5woFWS2mYhNUod9bvIIIrR3N+C6TypkpV3fzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 148/244] fec: Fix timer capture timing in `fec_ptp_enable_pps()`
Date:   Tue, 23 Aug 2022 10:25:07 +0200
Message-Id: <20220823080104.111648482@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Csókás Bence <csokas.bence@prolan.hu>

commit 61d5e2a251fb20c2c5e998c3f1d52ed6d5360319 upstream.

Code reimplements functionality already in `fec_ptp_read()`,
but misses check for FEC_QUIRK_BUG_CAPTURE. Replace with function call.

Fixes: 28b5f058cf1d ("net: fec: ptp: fix convergence issue to support LinuxPTP stack")
Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
Link: https://lore.kernel.org/r/20220811101348.13755-1-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -136,11 +136,7 @@ static int fec_ptp_enable_pps(struct fec
 		 * NSEC_PER_SEC - ts.tv_nsec. Add the remaining nanoseconds
 		 * to current timer would be next second.
 		 */
-		tempval = readl(fep->hwp + FEC_ATIME_CTRL);
-		tempval |= FEC_T_CTRL_CAPTURE;
-		writel(tempval, fep->hwp + FEC_ATIME_CTRL);
-
-		tempval = readl(fep->hwp + FEC_ATIME);
+		tempval = fep->cc.read(&fep->cc);
 		/* Convert the ptp local counter to 1588 timestamp */
 		ns = timecounter_cyc2time(&fep->tc, tempval);
 		ts = ns_to_timespec64(ns);


