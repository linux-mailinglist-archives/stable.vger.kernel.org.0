Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7250F689
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243565AbiDZI41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345948AbiDZIo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:44:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F275315E853;
        Tue, 26 Apr 2022 01:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D6261899;
        Tue, 26 Apr 2022 08:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B0BC385A4;
        Tue, 26 Apr 2022 08:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962035;
        bh=/BAm5NTJdX2tMlaApiM7QAkYP88sHZe13rGjL+RUOcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fj4oEAhOqMMwbIAlu+X/km143JPzW3XK0nSWeWVwwCKh1njxheUYtMo4hghXDyvNT
         B3SZbfQcnYRhqUpQApHLbaYcNIK3pArmgTHGmizdYMFMGDaT2ZEL3u4k2Ui7loFboU
         1aeXJhJuElTpzN2V011EttXYLp0ysX4j/657K0g0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Borislav Petkov <bp@suse.de>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.10 51/86] EDAC/synopsys: Read the error count from the correct register
Date:   Tue, 26 Apr 2022 10:21:19 +0200
Message-Id: <20220426081742.675332755@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

commit e2932d1f6f055b2af2114c7e64a26dc1b5593d0c upstream.

Currently, the error count is read wrongly from the status register. Read
the count from the proper error count register (ERRCNT).

  [ bp: Massage. ]

Fixes: b500b4a029d5 ("EDAC, synopsys: Add ECC support for ZynqMP DDR controller")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220414102813.4468-1-shubhrajyoti.datta@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/synopsys_edac.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -163,6 +163,11 @@
 #define ECC_STAT_CECNT_SHIFT		8
 #define ECC_STAT_BITNUM_MASK		0x7F
 
+/* ECC error count register definitions */
+#define ECC_ERRCNT_UECNT_MASK		0xFFFF0000
+#define ECC_ERRCNT_UECNT_SHIFT		16
+#define ECC_ERRCNT_CECNT_MASK		0xFFFF
+
 /* DDR QOS Interrupt register definitions */
 #define DDR_QOS_IRQ_STAT_OFST		0x20200
 #define DDR_QOSUE_MASK			0x4
@@ -418,15 +423,16 @@ static int zynqmp_get_error_info(struct
 	base = priv->baseaddr;
 	p = &priv->stat;
 
+	regval = readl(base + ECC_ERRCNT_OFST);
+	p->ce_cnt = regval & ECC_ERRCNT_CECNT_MASK;
+	p->ue_cnt = (regval & ECC_ERRCNT_UECNT_MASK) >> ECC_ERRCNT_UECNT_SHIFT;
+	if (!p->ce_cnt)
+		goto ue_err;
+
 	regval = readl(base + ECC_STAT_OFST);
 	if (!regval)
 		return 1;
 
-	p->ce_cnt = (regval & ECC_STAT_CECNT_MASK) >> ECC_STAT_CECNT_SHIFT;
-	p->ue_cnt = (regval & ECC_STAT_UECNT_MASK) >> ECC_STAT_UECNT_SHIFT;
-	if (!p->ce_cnt)
-		goto ue_err;
-
 	p->ceinfo.bitpos = (regval & ECC_STAT_BITNUM_MASK);
 
 	regval = readl(base + ECC_CEADDR0_OFST);


