Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA654ABA48
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384146AbiBGLYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240665AbiBGLKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2724C043181;
        Mon,  7 Feb 2022 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC4761261;
        Mon,  7 Feb 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D6FC340EB;
        Mon,  7 Feb 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232213;
        bh=XrtW0ZArxYJTRdmv3Z0rOi+EM5gu1mr+SJFAJDlw2WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gt0kPKV12StN30LDaalFy0aOilchEAGpqBJzy687g/m8O73hgZbvGSSzuDuFSpyq/
         UjyFTjwZSUk9egiUaAUyD0pjpKgKskoJnCPSsTh2Bn5A7cwFgKMvt+n/x/fyHQj3Wy
         DTtg/3xqP1GUPhXKFK8Ff168EVw+o329pe8LUwWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Borislav Petkov <bp@suse.de>, Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.9 46/48] EDAC/altera: Fix deferred probing
Date:   Mon,  7 Feb 2022 12:06:19 +0100
Message-Id: <20220207103753.828046068@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
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
@@ -363,7 +363,7 @@ static int altr_sdram_probe(struct platf
 	if (irq < 0) {
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "No irq %d in DT\n", irq);
-		return -ENODEV;
+		return irq;
 	}
 
 	/* Arria10 has a 2nd IRQ */


