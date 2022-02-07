Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C794ABB80
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376424AbiBGL2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357277AbiBGLUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724E4C03FED1;
        Mon,  7 Feb 2022 03:20:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA566146B;
        Mon,  7 Feb 2022 11:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE19AC340EB;
        Mon,  7 Feb 2022 11:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232805;
        bh=YkQTuZLGjQq/zJrIaYhBnNfMbXV6eTz5WQEixjdOXIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nB7yAOCREj8m6LsyH02UTPLAk2uQPTvtwmqD/jO9T7betk3480l0qZohV1Sr4VUNL
         wvteLB5COMn37AYMFPWS6miOAQgAXxVLuKKSdl4z4h/CUtBIETch63Rm9OTygQ57CH
         l8AOopU38VTUcxG8R8LgwKiY+8bE8vTxKhpgRUXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 42/44] EDAC/xgene: Fix deferred probing
Date:   Mon,  7 Feb 2022 12:06:58 +0100
Message-Id: <20220207103754.529459066@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
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

commit dfd0dfb9a7cc04acf93435b440dd34c2ca7b4424 upstream.

The driver overrides error codes returned by platform_get_irq_optional()
to -EINVAL for some strange reason, so if it returns -EPROBE_DEFER, the
driver will fail the probe permanently instead of the deferred probing.
Switch to propagating the proper error codes to platform driver code
upwards.

  [ bp: Massage commit message. ]

Fixes: 0d4429301c4a ("EDAC: Add APM X-Gene SoC EDAC driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220124185503.6720-3-s.shtylyov@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/xgene_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/xgene_edac.c
+++ b/drivers/edac/xgene_edac.c
@@ -1922,7 +1922,7 @@ static int xgene_edac_probe(struct platf
 			irq = platform_get_irq(pdev, i);
 			if (irq < 0) {
 				dev_err(&pdev->dev, "No IRQ resource\n");
-				rc = -EINVAL;
+				rc = irq;
 				goto out_err;
 			}
 			rc = devm_request_irq(&pdev->dev, irq,


