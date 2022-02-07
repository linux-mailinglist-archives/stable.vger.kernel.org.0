Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A544ABB1E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381129AbiBGL03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356753AbiBGLN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:13:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F57C0401C1;
        Mon,  7 Feb 2022 03:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28634B80EE8;
        Mon,  7 Feb 2022 11:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EF1C004E1;
        Mon,  7 Feb 2022 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232404;
        bh=+Nxyqn9HuoEQlzbKhHgVB+8w/+IoiYP/Q9se7acyhjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OO0YOA07XVGLndpJ+zoDEf6daFXhZoZPkeLQQRTeB4puZ09jPFD/Dk7kA3Lc4A3EJ
         GmRdcyObjPVFyY1IQ0OF18RHkVSgADV/h0LDWYUkRv3bZc7EeHXw74KSrtG85p4B/N
         0mwiV7gJEnPtgO5lTtzR2Q/QT3H2gMcixb4+yHfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Borislav Petkov <bp@suse.de>, Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.14 67/69] EDAC/altera: Fix deferred probing
Date:   Mon,  7 Feb 2022 12:06:29 +0100
Message-Id: <20220207103757.836504837@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 279eb8575fdaa92c314a54c0d583c65e26229107 upstream.

The driver overrides the error codes returned by platform_get_irq() to
-ENODEV for some strange reason, so if it returns -EPROBE_DEFER, the
driver will fail the probe permanently instead of the deferred probing.
Switch to propagating the proper error codes to platform driver code
upwards.

  [ bp: Massage commit message. ]

Fixes: 71bcada88b0f ("edac: altera: Add Altera SDRAM EDAC support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220124185503.6720-2-s.shtylyov@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -357,7 +357,7 @@ static int altr_sdram_probe(struct platf
 	if (irq < 0) {
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "No irq %d in DT\n", irq);
-		return -ENODEV;
+		return irq;
 	}
 
 	/* Arria10 has a 2nd IRQ */


