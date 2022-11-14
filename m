Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF72A6280A0
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbiKNNHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbiKNNH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A92D2AE3B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C3BEB80EC0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61456C433D6;
        Mon, 14 Nov 2022 13:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431245;
        bh=nEZo3cQpMTxylYCYcyu04q5GwT66k6/EHpmiEMXvDog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bc7fy+o6G59JQm9Vo6wuau7UwiW5oqXwrtRrllx/SsZRf8c1wEUppsgo8f4jfRzVC
         I0NUSWavWlHfNNFFUioB1eQR139XbgnVsXfQ/KpM7umRHYexWZ9TLlkxqS/r5q7yi3
         sSS0p6CAt6ndmZ+rDiQFPWl/sbP1ngh9HCERpi1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 155/190] spi: intel: Use correct mask for flash and protected regions
Date:   Mon, 14 Nov 2022 13:46:19 +0100
Message-Id: <20221114124505.594485806@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 92a66cbf6b30eda5719fbdfb24cd15fb341bba32 upstream.

The flash and protected region mask is actually 0x7fff (30:16 and 14:0)
and not 0x3fff so fix this accordingly. While there use GENMASK() instead.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20221025062800.22357-1-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-intel.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-intel.c
+++ b/drivers/spi/spi-intel.c
@@ -52,17 +52,17 @@
 #define FRACC				0x50
 
 #define FREG(n)				(0x54 + ((n) * 4))
-#define FREG_BASE_MASK			0x3fff
+#define FREG_BASE_MASK			GENMASK(14, 0)
 #define FREG_LIMIT_SHIFT		16
-#define FREG_LIMIT_MASK			(0x03fff << FREG_LIMIT_SHIFT)
+#define FREG_LIMIT_MASK			GENMASK(30, 16)
 
 /* Offset is from @ispi->pregs */
 #define PR(n)				((n) * 4)
 #define PR_WPE				BIT(31)
 #define PR_LIMIT_SHIFT			16
-#define PR_LIMIT_MASK			(0x3fff << PR_LIMIT_SHIFT)
+#define PR_LIMIT_MASK			GENMASK(30, 16)
 #define PR_RPE				BIT(15)
-#define PR_BASE_MASK			0x3fff
+#define PR_BASE_MASK			GENMASK(14, 0)
 
 /* Offsets are from @ispi->sregs */
 #define SSFSTS_CTL			0x00


