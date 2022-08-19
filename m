Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E1D59A4F2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354347AbiHSQyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354351AbiHSQws (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:52:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E038E12CDE3;
        Fri, 19 Aug 2022 09:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43290CE26B7;
        Fri, 19 Aug 2022 16:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C40FC433D7;
        Fri, 19 Aug 2022 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925612;
        bh=lwuN6VTFP1zBL9eoIkTQqR16l7lBZMYs5E+TzRiZ2B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5JwbhQvLcZf+d3MkT9L4fLOyE1Zx2W9wxCDiB4OkhLpGqoHdR2mOTBhOFIrjBfvH
         HZ5MFquHOoOVWVpeVb8DrDeVihlHe+yUcM72eXjkKuOaXe6/JG/SqfOyfCxhO6DRGN
         XH6UG+jNocAYVVFKpVhLn4yQTmmrHg8OTvCcFQ4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 538/545] mtd: rawnand: arasan: Prevent an unsupported configuration
Date:   Fri, 19 Aug 2022 17:45:08 +0200
Message-Id: <20220819153853.664599425@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit fc9e18f9e987ad46722dad53adab1c12148c213c upstream.

Under the following conditions:
* after rounding up by 4 the number of bytes to transfer (this is
  related to the controller's internal constraints),
* if this (rounded) amount of data is situated beyond the end of the
  device,
* and only in NV-DDR mode,
the Arasan NAND controller timeouts.

This currently can happen in a particular helper used when picking
software ECC algorithms. Let's prevent this situation by refusing to use
the NV-DDR interface with software engines.

Fixes: 4edde6031458 ("mtd: rawnand: arasan: Support NV-DDR interface")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211008163640.1753821-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -891,6 +891,21 @@ static int anfc_setup_interface(struct n
 		nvddr = nand_get_nvddr_timings(conf);
 		if (IS_ERR(nvddr))
 			return PTR_ERR(nvddr);
+
+		/*
+		 * The controller only supports data payload requests which are
+		 * a multiple of 4. In practice, most data accesses are 4-byte
+		 * aligned and this is not an issue. However, rounding up will
+		 * simply be refused by the controller if we reached the end of
+		 * the device *and* we are using the NV-DDR interface(!). In
+		 * this situation, unaligned data requests ending at the device
+		 * boundary will confuse the controller and cannot be performed.
+		 *
+		 * This is something that happens in nand_read_subpage() when
+		 * selecting software ECC support and must be avoided.
+		 */
+		if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_SOFT)
+			return -ENOTSUPP;
 	} else {
 		sdr = nand_get_sdr_timings(conf);
 		if (IS_ERR(sdr))


