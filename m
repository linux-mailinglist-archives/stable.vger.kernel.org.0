Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91D55B2429
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 19:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiIHREO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 13:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiIHREN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 13:04:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21359EB872
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 10:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7320CB818B5
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 17:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55F9C433D6;
        Thu,  8 Sep 2022 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662656650;
        bh=yFq1dRGVzq1pjNu+qcg7+g8oFLnUsizTm0HUYaexzCg=;
        h=Subject:To:Cc:From:Date:From;
        b=MR3lM9p6KHkbqBBx+SNUO1qtGPRsDYkgH4TF8I111dOiaQqTebiSPTelyyk4a17iq
         uApp+ibMtm73UyIgTA4dC3zYwqJmxiJzpiOe3SGrsZu4NxXj18JJX/u/OlWqEvSqRq
         wGCL/g2fxcSuA40Nd8jv/wfPQbIGjhEnXJ6kW3Gc=
Subject: FAILED: patch "[PATCH] soc: fsl: select FSL_GUTS driver for DPIO" failed to apply to 5.10-stable tree
To:     matt@traverse.com.au, arnd@arndb.de, ioana.ciornei@nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Sep 2022 19:04:26 +0200
Message-ID: <16626566664259@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9a472613f5bc ("soc: fsl: select FSL_GUTS driver for DPIO")
69651bd8d303 ("soc: fsl: dpio: add Net DIM integration")
ed1d2143fee5 ("soc: fsl: dpio: add support for irq coalescing per software portal")
2cf0b6fe9bd3 ("soc: fsl: dpio: extract the QBMAN clock frequency from the attributes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9a472613f5bccf1b36837423495ae592a9c5182f Mon Sep 17 00:00:00 2001
From: Mathew McBride <matt@traverse.com.au>
Date: Thu, 1 Sep 2022 05:21:49 +0000
Subject: [PATCH] soc: fsl: select FSL_GUTS driver for DPIO

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

diff --git a/drivers/soc/fsl/Kconfig b/drivers/soc/fsl/Kconfig
index 07d52cafbb31..fcec6ed83d5e 100644
--- a/drivers/soc/fsl/Kconfig
+++ b/drivers/soc/fsl/Kconfig
@@ -24,6 +24,7 @@ config FSL_MC_DPIO
         tristate "QorIQ DPAA2 DPIO driver"
         depends on FSL_MC_BUS
         select SOC_BUS
+        select FSL_GUTS
         select DIMLIB
         help
 	  Driver for the DPAA2 DPIO object.  A DPIO provides queue and

