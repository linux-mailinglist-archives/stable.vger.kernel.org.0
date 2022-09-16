Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CD85BAA69
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiIPKNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiIPKMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81B4A99C9;
        Fri, 16 Sep 2022 03:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 162CDB82518;
        Fri, 16 Sep 2022 10:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F70BC433C1;
        Fri, 16 Sep 2022 10:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322997;
        bh=S07XMmLlcm/5xYS+ZKU7ruAv+2iVf9I/7rxvTXJEHGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yb6EdPBbRRrZgbD3Ey5kD2noIjIQwBiGwOoLNnGR9RtMH1/DAGvyufDx2PB2im2co
         r0FHv/J3ewma3k3G6H7BHIISwUIiMqQMFgPd4Uij+y8U0nB9PD7xn++AN9UxcVUADg
         GzcK0wRrpyb3LlB6NehYvy6Z66H9xy8PIivzvF0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathew McBride <matt@traverse.com.au>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 13/14] soc: fsl: select FSL_GUTS driver for DPIO
Date:   Fri, 16 Sep 2022 12:08:20 +0200
Message-Id: <20220916100443.766339299@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
References: <20220916100443.123226979@linuxfoundation.org>
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

From: Mathew McBride <matt@traverse.com.au>

commit 9a472613f5bccf1b36837423495ae592a9c5182f upstream.

The soc/fsl/dpio driver will perform a soc_device_match()
to determine the optimal cache settings for a given CPU core.

If FSL_GUTS is not enabled, this search will fail and
the driver will not configure cache stashing for the given
DPIO, and a string of "unknown SoC" messages will appear:

fsl_mc_dpio dpio.7: unknown SoC version
fsl_mc_dpio dpio.6: unknown SoC version
fsl_mc_dpio dpio.5: unknown SoC version

Fixes: 51da14e96e9b ("soc: fsl: dpio: configure cache stashing destination")
Signed-off-by: Mathew McBride <matt@traverse.com.au>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220901052149.23873-2-matt@traverse.com.au'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/fsl/Kconfig
+++ b/drivers/soc/fsl/Kconfig
@@ -24,6 +24,7 @@ config FSL_MC_DPIO
         tristate "QorIQ DPAA2 DPIO driver"
         depends on FSL_MC_BUS
         select SOC_BUS
+        select FSL_GUTS
         help
 	  Driver for the DPAA2 DPIO object.  A DPIO provides queue and
 	  buffer management facilities for software to interact with


