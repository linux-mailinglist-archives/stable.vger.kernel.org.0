Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDBF505700
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbiDRNpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbiDRNmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C9830F7B;
        Mon, 18 Apr 2022 05:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D17CB80D9C;
        Mon, 18 Apr 2022 12:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D03C385A1;
        Mon, 18 Apr 2022 12:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286772;
        bh=oDeTHARGZEfrXPcCeIWg2xEfZgIW08C61yBMEcE/0AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3GjPj8Wf4Erj3AodwolM18FBjE0obxre4aN6JrogFagVRqjdv9kW8C4kRoi0zexx
         603sJmo+XrSAH5Y8wJAEt0Bu9c/zn1yixZtjl+VbbKCeyC52dMmAqM+p17e080gAoZ
         T3XRURRWoewiPQ/Qkknse9IvLPmIoQswAQtnFh7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 240/284] scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()
Date:   Mon, 18 Apr 2022 14:13:41 +0200
Message-Id: <20220418121218.623771234@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 16ed828b872d12ccba8f07bcc446ae89ba662f9c ]

The error handling path of the probe releases a resource that is not freed
in the remove function. In some cases, a ioremap() must be undone.

Add the missing iounmap() call in the remove function.

Link: https://lore.kernel.org/r/247066a3104d25f9a05de8b3270fc3c848763bcc.1647673264.git.christophe.jaillet@wanadoo.fr
Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/zorro7xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index aff31991aea9..ee6d97473853 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -158,6 +158,8 @@ static void zorro7xx_remove_one(struct zorro_dev *z)
 	scsi_remove_host(host);
 
 	NCR_700_release(host);
+	if (host->base > 0x01000000)
+		iounmap(hostdata->base);
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	zorro_release_device(z);
-- 
2.35.1



